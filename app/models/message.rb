class Message < ActiveRecord::Base
  belongs_to :campaign

  validates :text, presence: true, length: 10..300
end
