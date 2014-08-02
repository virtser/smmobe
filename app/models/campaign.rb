class Campaign < ActiveRecord::Base
  belongs_to :organization
  belongs_to :template
end
