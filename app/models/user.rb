class User < ActiveRecord::Base

  has_one :avatar, :as => :avatarable, :dependent => :destroy

  has_many :reports, :dependent => :destroy

  #has_and_belongs_to_many :roles

  belongs_to :user_type

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :remember_me, :password_confirmation, :first_name, :last_name, :phone_number, :avatar_attributes, :user_type_id

  validates :user_type_id, :presence => true

  accepts_nested_attributes_for :avatar

  def name
    [first_name,last_name].join(" ")
  end

  def roles
    user_type.roles
  end

  def get_avatar
    return self.avatar if self.avatar.present?
    return self.build_avatar
  end

  def get_assigned_shops
    assigned_tasks = Task.find_all_by_assigned_to(self)
    return assigned_tasks.collect(&:shop).flatten
  end
  
end  
