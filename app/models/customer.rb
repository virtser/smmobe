class Customer < ActiveRecord::Base
  belongs_to :campaign

  validates :name, presence: true, length: 5..80
  validates :phone, presence: true, length: 9..20

end
