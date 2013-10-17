class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :validatable, :recoverable, :trackable, 
  devise :database_authenticatable, :registerable, :rememberable,
         :omniauthable, :omniauth_providers => [:google_oauth2, :facebook]
         
  has_many :usersessions

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid
  # attr_accessible :title, :body
  
  # Make the name the email address before "@"
  def name
    name = read_attribute(:name)
    email = read_attribute(:email)
    if name.nil? or name.empty?
      email.split("@").first
    else
      name.split(" ").first
    end    
  end
  
  # Retrieve user from facebook auth
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    # Create user if not exists
    unless user
      user = User.create(
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid:auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0,20]
      )
    end
    user
  end
  
  # Retrieve user from google access token
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => "google", :email => data["email"]).first  
    # Create user if not exists
    unless user
      name = data["email"].split("@").first
      name = data["name"] if data["name"]
      user = User.create( 
        name: name, 
        email: data["email"], 
        password: Devise.friendly_token[0,20],
        provider: "google",
        uid: data["email"]
      )
    end
    user
  end
  
end
