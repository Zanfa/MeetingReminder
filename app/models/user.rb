class User < ActiveRecord::Base

  has_many :events

  def self.find_or_create_from_auth_hash(auth_hash)
    User.where(
        google_id: auth_hash[:uid],
    ).first_or_create do |user|
      user.email = auth_hash[:extra][:raw_info][:email]
      user.access_token = auth_hash[:credentials][:token]
      user.refresh_token = auth_hash[:credentials][:refresh_token]
    end
  end

end
