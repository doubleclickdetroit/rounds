module Common
  module Scopes
    module Recent
      # module ClassMethods
      #   # friends_recent was here
      # end

      def self.included(base)
        # base.extend(ClassMethods)

        # module_name = self.to_s
        base.class_eval do
          # todo breaking heroku...
          # raise "#{self.to_s} must have an attribute 'id' to include #{module_name}" unless self.new.respond_to?(:id)

          # todo remove
          scope :of_type, lambda {|type| where :type => type}

          scope :recent, :order => 'created_at desc', :limit => 8
        end
      end
    end

    module Friends
      def self.included(base)
        # module_name = self.to_s
        base.class_eval do
          # todo breaking heroku...
          # raise "#{self.to_s} must have an attribute 'id' to include #{module_name}" unless self.new.respond_to?(:id)

          scope :by_friends_for_user, lambda {|user|
            user_id_arr = user.friend_ids

            # todo cleaner?
            return where('1 = 0') if user_id_arr.empty?

            cond_str = user_id_arr.inject('') do |str,user_id|
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
        # module_name = self.to_s
        base.class_eval do
          # todo breaking heroku...
          # raise "#{self.to_s} must have an attribute 'id' to include #{module_name}" unless self.new.respond_to?(:id)

          scope :before, lambda {|time| where(["created_at < ?", time])}
        end
      end
    end
  end

  module Associations
    module HasCreator
      def self.included(base)
        module_name = self.to_s
        base.class_eval do
          # todo breaking heroku...
          # raise "#{self.to_s} must have an attribute 'id' to include #{module_name}" unless self.new.respond_to?(:id)

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
end
