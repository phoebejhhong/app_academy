class User < ActiveRecord::Base
  attr_reader :password

  validates :username, :password_digest, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }


  has_many :cats
  has_many :session_tokens

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  private

  # don't need this because we're alowing multiple logins
  # def reset_session_token
  #   self.session_token = SecureRandom.urlsafe_base64
  #   self.save!
  # end

end
