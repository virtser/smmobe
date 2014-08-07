class AddMessageTypeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :campaign_type_id, :integer
  end
end
