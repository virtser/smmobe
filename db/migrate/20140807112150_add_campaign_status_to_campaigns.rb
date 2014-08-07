class AddCampaignStatusToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :campaign_status_id, :integer, :null => false, :default => 1
  end
end
