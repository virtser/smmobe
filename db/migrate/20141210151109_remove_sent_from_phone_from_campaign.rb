class RemoveSentFromPhoneFromCampaign < ActiveRecord::Migration
  def change
    remove_column :campaigns, :sent_from_phone, :string
  end
end
