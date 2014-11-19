class Customer < ActiveRecord::Base
  belongs_to :campaign

  #validates :first_name, presence: true, length: 2..80
  validates :phone, :numericality => {:only_integer => true}, presence: true, length: 9..15

end
