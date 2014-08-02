class Organization < ActiveRecord::Base
  has_many :users
  has_many :customers
  has_many :campaigns
end
