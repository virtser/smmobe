class Message < ActiveRecord::Base
  #has_many :campaign

  validates :text, presence: true, length: 10..200
end
