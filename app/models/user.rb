class User < ActiveRecord::Base
  belongs_to :organization

  validates :name, presence: true, length: 5..80
  validates :email, presence: true, email: true, uniqueness: { case_sensitive: false }
  validates :phone, presence: true, length: 9..20
  validates :password, :presence => true, length: 6..16

  before_save { self.email = email.downcase }
end
