class User < ActiveRecord::Base

  has_one :avatar, :as => :avatarable, :dependent => :destroy

  has_many :reports, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :remember_me, :password_confirmation, :first_name, :last_name, :phone_number, :avatar_attributes

  accepts_nested_attributes_for :avatar

  def name
    [first_name,last_name].join(" ")
  end

end
