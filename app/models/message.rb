class Message < ActiveRecord::Base
  has_one :message_type
end
