class User < ActiveRecord::Base
  belongs_to :organization

  validates :name, presence: true, length: 5..80
  validates :email, presence: true, email: true
  validates :phone, presence: true, length: 9..20
  validates :password, :presence => true, length: 6..12
end
