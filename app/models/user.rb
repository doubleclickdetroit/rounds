class User < ActiveRecord::Base
  # todo left over from devise...
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authorizations

  has_many :rounds
  has_many :slides
  has_many :comments
  has_many :watchings

  has_many :blacklist_entries


  # todo as scopes
  def filter_blocked(klass)
    klass.where(['user_id NOT IN (?)', blocked_user_ids]).eight_most_recent
  end

  def recent(klass)
    filter_blocked(klass).eight_most_recent
  end

  def friends(klass)
    filter_blocked(klass).where(['user_id IN (?)', friend_ids])
  end

  # scope :eight_most_recent, :order => 'created_at desc', :limit => 8
  # scope :before, lambda {|id| where(["id < ?", id])}
  # scope :after,  lambda {|id| where(["id > ?", id])}
  # scope :before_or_after, lambda {|params|
  #   offset = nil
  #   if val = params[:before] 
  #     offset = [:before, val]
  #   elsif val = params[:after]
  #     offset = [:after, val]
  #   end

  #   # todo                                     kludgey
  #   offset.is_a?(Array) ? self.send(*offset) : where('1 = 1')
  # }


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
