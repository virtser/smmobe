class Customer < ActiveRecord::Base
  belongs_to :campaign

  validates :first_name, presence: true, length: 2..80
  validates :phone, presence: true, length: 9..20

end
