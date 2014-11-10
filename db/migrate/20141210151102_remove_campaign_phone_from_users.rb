class RemoveCampaignPhoneFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :campaign_phone, :string
  end
end
