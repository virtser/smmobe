class AddSentFromPhoneToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :sent_from_phone, :string
  end
end
