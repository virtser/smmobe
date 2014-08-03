class Message < ActiveRecord::Base
  has_one :message_type
  belongs_to :campaign
end
