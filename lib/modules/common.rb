module Common
  module Scopes
    module Recent
      module ClassMethods
        def recent(user)
          filter_blocked_for(user).eight_most_recent
        end
      end

      def self.included(base)
        base.extend ClassMethods

        base.class_eval do
          scope :filter_blocked_for, lambda {|user|
            user_id_arr = user.blocked_user_ids

            # todo cleaner? awful?
            return where('1 = 1') if user_id_arr.empty?

            where(['user_id NOT IN (?)', user_id_arr])
          }

          scope :eight_most_recent, :order => 'created_at desc', :limit => 8
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

    module BeforeAndAfter
      def self.included(base)
        base.class_eval do
          scope :before, lambda {|id| where(["id < ?", id])}
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
