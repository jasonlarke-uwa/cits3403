class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :first_name, :last_name, :password_confirmation, :remember_me
 
  validates_presence_of :first_name
  validates_presence_of :last_name
  # attr_accessible :title, :body
  has_many :user_roles
  has_many :roles, :through => :user_roles
  
  def has_role?(role_name)
	roles.exists?(:name => role_name)
  end
  
  def has_any_roles?(role_names)
	roles.exists?(:name => role_names)
  end
  
  def has_all_roles?(role_names)
	names = roles.where(:name => role_names).map{|x| x.name}
	(role_names - names).empty?
  end
end
