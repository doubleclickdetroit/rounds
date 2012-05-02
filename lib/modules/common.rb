module Common
  module Scopes
    module FriendsAndRecent
      module ClassMethods
        def friends_recent(fid_arr)
          friends(fid_arr).recent
        end
      end

      def self.included(base)
        base.extend(ClassMethods)

        module_name = self.to_s
        base.class_eval do
          # todo breaking heroku...
          # raise "#{self.to_s} must have an attribute 'fid' to include #{module_name}" unless self.new.respond_to?(:fid)

          # todo not really FriendsAndRecent...
          scope :of_type, lambda {|type| where :type => type}

          scope :before, lambda {|time| where(["created_at < ?", time])}
          # scope :before, lambda {|time|
          #   where(["created_at < ?", time]).order('created_at desc').limit(8)
          # }

          scope :recent, :order => 'created_at desc', :limit => 8

          scope :friends, lambda {|fid_arr|
            return limit(0) if fid_arr.empty?

            cond_str = fid_arr.inject('') do |str,fid|
              str << " OR " unless str.empty?
              str << "fid = #{fid}"
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
          # raise "#{self.to_s} must have an attribute 'fid' to include #{module_name}" unless self.new.respond_to?(:fid)

          belongs_to :created_by, :class_name => 'User', :foreign_key => :fid, :primary_key => :fid
        end
      end

      def creator
        created_by
      end
    end
  end
end
