class CreateCampaignStatuses < ActiveRecord::Migration
  def change
    create_table :campaign_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
