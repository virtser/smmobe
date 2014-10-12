class AddCampaignidToMessageReceives < ActiveRecord::Migration
  def change
    add_column :message_receives, :campaign_id, :integer
  end
end
