class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :rounds, :class_name => 'Round', :foreign_key => :fid, :primary_key => :fid
  # has_many :slides, :class_name => 'Slide', :foreign_key => :fid, :primary_key => :fid
  # has_many :comments, :class_name => 'Comment', :foreign_key => :fid, :primary_key => :fid
end
