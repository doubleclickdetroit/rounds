module Common
  module Scopes
    module Recent
      def self.included(base)
        base.class_eval do
          scope :recent, :order => 'created_at desc', :limit => 8
        end
      end
    end

    module Friends
      def self.included(base)
        base.class_eval do
          scope :by_friends_for_user, lambda {|user|
            user_id_arr = user.friend_ids

            # todo cleaner?
            return where('1 = 0') if user_id_arr.empty?

            where(['user_id IN (?)', user_id_arr])
          }
        end
      end
    end

    module Unfriends
      def self.included(base)
        base.class_eval do
          scope :by_friends_for_user, lambda {|user|
            user_id_arr = user.friend_ids

            # todo cleaner?
            return where('1 = 0') if user_id_arr.empty?

            friends_id_str = user_id_arr.inject('') do |str,user_id|
              str << " OR " unless str.empty?
              str << "user_id = #{user_id}"
            end

            where(cond_str)
          }
        end
      end
    end

    module BeforeAndAfter
      def self.included(base)
        base.class_eval do
          scope :before, lambda {|time| where(["created_at < ?", time])}
        end
      end
    end
  end

  module Associations
    module HasCreator
      def self.included(base)
        base.class_eval do
          belongs_to :user
        end
      end

      # todo clean up what follows

      # todo by alias
      def created_by
        user
      end

      def created_by=(user)
        self.user = user
      end

      # todo by alias
      def creator
        created_by
      end

      def creator=(user)
        self.created_by = user
      end
    end
  end

  module Helpers
    # def remove_blocked_user_ids_from(user_ids_arr)
    #   (Set.new(user_ids_arr) ^ blocked_user_ids).to_a
    # end

    # # todo maybe not the most effecient
    # def reject_blocked(items)
    #   user_ids = blocked_user_ids
    #   items.reject do |item|
    #     user_ids.include? item.user_id
    #   end
    # end
  end
end
