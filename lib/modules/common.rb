module Common
  module Scopes
    module FriendsAndRecent
      module ClassMethods
        def friends_recent(user_id_arr)
          friends(user_id_arr).recent
        end
      end

      def self.included(base)
        base.extend(ClassMethods)

        module_name = self.to_s
        base.class_eval do
          # todo breaking heroku...
          # raise "#{self.to_s} must have an attribute 'user_id' to include #{module_name}" unless self.new.respond_to?(:user_id)

          # todo not really FriendsAndRecent...
          scope :of_type, lambda {|type| where :type => type}

          scope :before, lambda {|time| where(["created_at < ?", time])}

          scope :recent, :order => 'created_at desc', :limit => 8

          scope :friends, lambda {|user_id_arr|
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

  end

  module Associations
    module HasCreator
      def self.included(base)
        module_name = self.to_s
        base.class_eval do
          # todo breaking heroku...
          # raise "#{self.to_s} must have an attribute 'user_id' to include #{module_name}" unless self.new.respond_to?(:user_id)

          belongs_to :created_by, :class_name => 'User', :foreign_key => :user_id, :primary_key => :user_id
        end
      end

      # todo by alias
      def creator
        created_by
      end
    end
  end
end
