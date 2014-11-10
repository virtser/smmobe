class Phone < ActiveRecord::Base
  belongs_to :campaign

  validates :phone, presence: true, length: 9..20
end
