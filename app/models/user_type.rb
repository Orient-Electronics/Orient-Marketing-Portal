class UserType < ActiveRecord::Base

  has_many :users

  has_and_belongs_to_many :roles

  attr_accessible :name, :role_ids
end
