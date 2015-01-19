class User
  include Mongoid::Document
  field :first_name, :type => String
  field :last_name, :type => String
  field :email, :type => String
  field :access_token, :type => String

  validates_presence_of :email, :first_name, :last_name, :access_token


  def self.create_user_from_fb(profile, access_token)
    existing_user = User.where(email: profile[:email]).first
    return existing_user if existing_user.present?

    keys = [:first_name, :last_name, :email, :access_token]
    needed_info = profile.select{|k,_| keys.include?(k) }
    User.create(needed_info.merge(access_token: access_token))
  end

end
