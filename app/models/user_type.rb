class UserType < ActiveRecord::Base

  has_many :users

  has_and_belongs_to_many :roles

  attr_accessible :name, :role_ids

  validates_presence_of :name, :role_ids, :presence => true   
end
