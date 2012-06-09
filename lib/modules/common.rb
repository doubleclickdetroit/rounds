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

          scope :eight_most_recent, lambda { limit(8).order("#{self.table_name}.id DESC") }
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
          scope :after,  lambda {|id| where(["id > ?", id])}

          scope :before_or_after, lambda {|params|
            offset = nil
            if val = params[:before] 
              offset = [:before, val]
            elsif val = params[:after]
              offset = [:after, val]
            end
            
            # todo                                     kludgey
            offset.is_a?(Array) ? self.send(*offset) : where('1 = 1')
          }
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

  module Finders
    module ClassMethods
      # the firehose, but with :limit => 8,
      # sorted, with users blocked as needed, 
      # and with before/after taken care of.
      def community_feed(*args)
        # todo make this more readable?
        user = args.shift
        args = args.extract_options!

        if val = args[:before] 
          @offset = [:before, val]
        elsif val = args[:after]
          @offset = [:after, val]
        end

        # send performs before/after if there is an offset
        slides = (@offset ? self.send(*@offset) : self).recent(user)
      end

      # todo ensure this ActiveRelation is performant 
      def feed_by_user_and_pagination(user, params)
        # the firehose, but already with :limit => 8,
        # sorted, with users blocked as needed, and
        # with before/after taken care of.
        #
        # a .where is chained to only return records
        # created by the User record passed in.
        community_feed(user, params).where(:user_id => user.id)
      end
    end

    def self.included(base)
      base.extend ClassMethods
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
