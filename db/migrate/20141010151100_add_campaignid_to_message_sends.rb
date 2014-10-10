class AddCampaignidToMessageSends < ActiveRecord::Migration
  def change
    add_column :message_sends, :campaign_id, :integer
  end
end
