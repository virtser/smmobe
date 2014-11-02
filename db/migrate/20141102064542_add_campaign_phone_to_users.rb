class AddCampaignPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :campaign_phone, :string
  end
end
