class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :validatable, :recoverable, :trackable, 
  devise :database_authenticatable, :registerable, :rememberable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
         
  has_many :usersessions

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  # Make the name the email address before "@"
  def name
    email = read_attribute(:email)
    if email.nil? or email.empty?
      "Inspector"
    else
      email.split("@").first
    end    
  end
  
  # Retrieve user from google access token
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first  
    # Create user if not exists
    unless user
      user = User.create( email: data["email"], password: Devise.friendly_token[0,20] )
    end
    user
  end
  
end
