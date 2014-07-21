class User < ActiveRecord::Base

  include PublicActivity::Common

  has_one :avatar, :as => :avatarable, :dependent => :destroy

  has_many :reports, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :created_tasks, :foreign_key => 'assigned_by', :class_name => "Task", :dependent => :destroy
  has_many :assigned_tasks, :foreign_key => 'assigned_to', :class_name => "Task", :dependent => :destroy

  has_many :posts, :dependent => :destroy
  has_many :subscribers, :dependent => :destroy
  #has_and_belongs_to_many :roles

  belongs_to :user_type

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :remember_me, :password_confirmation, :first_name, :last_name, :phone_number, :avatar_attributes, :user_type_id, :subscribers_attributes, :view_announcement

  validates :user_type_id, :presence => true

  accepts_nested_attributes_for :avatar
  accepts_nested_attributes_for :subscribers
  before_destroy :remove_public_activities, :remove_subscribers


  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "User").destroy_all
  end

  def remove_subscribers
    Subscriber.where(:subscribe_id => self.id).destroy_all
  end

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
    assigned_shops = Task.find_all_by_assigned_to(self)
    return assigned_shops.collect(&:shop).flatten
  end

  def user_admin?
    user_type.try(:name) == "admin"
  end

  def user_employee?
    user_type.try(:name) == "employee"
  end

  def user_manager?
    user_type.try(:name) == "manager"
  end

  def already_subscribe?(user)
    self.subscribers.find_by_subscribe_id(user.id).blank? ? false : true
  end

  def can_view_announcement?
    self.view_announcement
  end

  def can_remove_comment?(comment)
    return true if comment.user == self
    return false
  end

  def post_owner?(post)
    self == post.user
  end
end
