class User < ActiveRecord::Base
  # todo left over from devise...
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authorizations

  has_many :rounds
  has_many :slides
  has_many :comments
  has_many :ballots
  has_many :watchings
  has_many :invitations, :foreign_key => :invited_user_id, :primary_key => :id

  has_many :blacklist_entries


  # todo as scopes?
  def own(klass)
    plural_sym = klass.to_s.pluralize.downcase.intern

    instances = self.send plural_sym
    instances.eight_most_recent
  end

  def filter_blocked(klass)
    ids = blocked_user_ids
    ids.empty? ? klass.eight_most_recent : klass.where(['user_id NOT IN (?)', ids]).eight_most_recent 
  end

  def recent(klass)
    # filter_blocked also sorts/limits
    filter_blocked(klass).where(['user_id NOT IN (?)', [self.id]])
  end

  def friends(klass)
    # filter_blocked also sorts/limits
    filter_blocked(klass).where(['user_id IN (?)', friend_ids])
  end


  def self.via_auth(auth_hash)
    auth = Authorization.find_or_initialize_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])

    if auth.new_record?
      user = User.create(:name => auth_hash['info']['name'])

      # todo this sucks, fix it
      auth.user = user
      auth.save
      user
    else
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
      # todo test this caching...
      @friend_ids ||= friend_ids_csv.split(',')
    end
  end

  def friend_ids=(arr)
    raise ArgumentError unless arr.is_a?(Array)
    self.friend_ids_csv = arr.join(',')
  end

  def blocked_user_ids
    blacklist_entries.map {|ble| ble.blocked_user_id}
  end

end
