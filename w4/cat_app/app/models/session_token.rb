class SessionToken < ActiveRecord::Base
  attr_accessor :ip_address

  validates :user_id, :session_token, presence: true

  after_initialize :ensure_session_token, :geocode

  geocoded_by :ip_address

  belongs_to :user

  private
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def get_geocode

  end
end
