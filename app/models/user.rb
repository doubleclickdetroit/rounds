class User < ActiveRecord::Base
  # todo left over from devise...
  # todo friend_ids_csv should not be accessible?
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authorizations

  has_many :rounds
  has_many :slides
  has_many :comments
  has_many :ballots
  has_many :watchings # , where(['watchings.type = ?', nil])
  has_many :dibs
  has_many :invitations, :foreign_key => :invited_user_id, :primary_key => :id

  has_many :blacklist_entries


  # todo as scopes?
  
  # for /api/users
  def own(klass)
    plural_sym = klass.to_s.pluralize.downcase.intern

    instances = self.send plural_sym
    instances.eight_most_recent
  end

  # for /api/sentences|pictures
  def remove(*args)
    arr   = args.first.is_a?(Array) ? args.shift : [args.shift]
    klass = args.extract_options![:from]

    results = klass.eight_most_recent

    ignored_ids  = [self.id]
    ignored_ids |= blocked_user_ids if arr.include? :blocked
    ignored_ids |= friend_ids       if arr.include? :friends
    results = results.where(['slides.user_id NOT IN (?)', ignored_ids]) 

    results = results.includes(:round).where(['rounds.private = ?', false]) if arr.include? :private
    results = results.where(['slides.ready = ?', true]) if arr.include? :not_ready

    results
  end

  def community(klass)
    # remove also sorts/limits
    slides = remove([:blocked,:friends,:not_ready], from: klass)
  end

  def set_friends(provider, uids)
    contains_non_int = uids.any? {|uid| uid !~ /\d+/}
    raise ArgumentError, 'All uids must be integer strings' if contains_non_int
    
    hash     = { provider => {} }
    user_ids = []

    uids.each do |uid|
      user_id = Authorization.find_by_provider_and_uid(provider, uid).try(:user_id)
      unless user_id.nil?
        user_ids << user_id
        hash[provider][uid] = user_id
      end
    end

    puts "#### friend ids #{user_ids}"
    self.friend_ids = user_ids
    self.save
    puts "#### friend ids #{self.reload.friend_ids}"

    hash
  end

  def friends(klass)
    # remove also sorts/limits
    remove([:blocked,:private,:not_ready], from: klass).where(['slides.user_id IN (?)', friend_ids])
  end

  def private(klass)
    raise ArgumentError unless [Sentence,Picture].include? klass 
    # remove also sorts/limits
    slides = remove([:blocked,:not_ready], from: klass)

    # select only slides from private rounds
    private_round_ids = self.invitations.private.map(&:round_id)
    slides = slides.where(['slides.round_id IN (?)', private_round_ids])
  end

  def self.via_auth(auth_hash)
    provider, uid = auth_hash['provider'], auth_hash['uid']
    auth = Authorization.find_or_initialize_by_provider_and_uid(provider, uid)

    # todo this is flawed if we use anything other than facebook
    if auth.new_record?
      info = auth_hash['info']
      user = User.create(name: info['name'], image_path: info['image'])

      # todo move this
      # check for Invitations for provider/uid
      Invitation.where(invited_provider: provider, invited_uid: uid).each do |inv|
        inv.invited_user_id = user.id
        inv.save
      end

      # todo this sucks, fix it
      auth.user = user
      auth.save
      user
    else
      # auth.token = auth_hash['credentials']['token']
      # auth.save
      user = auth.user
    end
  end

  def self.find_by_auth_hash(hash)
    auth = Authorization.find_by_provider_and_uid(hash['provider'], hash['uid'])
    auth.try(:user)
  end

  def friend_ids
    if friend_ids_csv.nil?
      return []
    else
      # todo caching...
      # @friend_ids ||= friend_ids_csv.split(',')
      friend_ids_csv.split(',')
    end
  end

  def blocked_user_ids
    blacklist_entries.map {|ble| ble.blocked_user_id}
  end

  def invite(*args)
    invitees = args.shift
    round    = args.extract_options![:to]
    raise ArgumentError, 'Must include to: round' unless round.is_a?(Round)

    invitees.each do |provider, array|
      array.each do |uid|
        invitation = { user_id: self.id, round_id: round.id }

        if provider == 'user_ids'
          invitation[:invited_user_id] = uid
        else
          invitation.merge!({invited_provider:provider, invited_uid:uid})
        end

        Invitation.create invitation
      end
    end
  end

# todo
# private
  # accessed by .set_friends(provider, uids)
  def friend_ids=(arr)
    raise ArgumentError unless arr.is_a?(Array)
    self.friend_ids_csv = arr.join(',')
  end
end
