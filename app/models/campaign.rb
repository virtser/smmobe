class Campaign < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign_type
  belongs_to :campaign_status
  has_one :message
  has_many :customers

  validates :title, presence: true, length: 3..80
  #validates :description, presence: true, length: 5..500
end
