class Campaign < ActiveRecord::Base
  belongs_to :campaign_type
  belongs_to :campaign_status
  #belongs_to :message

  validates :title, presence: true, length: 3..80
  validates :description, presence: true, length: 5..500
end
