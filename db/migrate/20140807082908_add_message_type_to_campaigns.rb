class AddMessageTypeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :campaign_type_id, :integer, :null => false, :default => 1
  end
end
