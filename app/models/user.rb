class User < ActiveRecord::Base
  belongs_to :organization

  validates :name, presence: true,
            :length => {:within => 5..80}
  validates :email, :presence => true,
            :email => true
  validates :phone, presence: true,
            :length => {:within => 9..20}
  validates :password, :presence => true,
            :length => {:within => 6..12}
end
