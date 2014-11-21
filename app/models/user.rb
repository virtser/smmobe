class User < ActiveRecord::Base
  has_many :campaigns

  before_create :create_remember_token
  before_save { self.email = email.downcase } # lowercase email address before save

  validates :name, presence: true, length: 5..80
  validates :email, presence: true, email: true,
            uniqueness: { case_sensitive: false }
  validates :phone, presence: true, length: 9..20, :numericality => {:only_integer => true}

  has_secure_password
  validates :password, presence: true, length: 6..16, on: create


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end

end
