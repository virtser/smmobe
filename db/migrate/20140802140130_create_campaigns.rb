class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.string :description
      t.integer :template_id
      t.integer :organization_id

      t.timestamps
    end
  end
end
