class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :phone
      t.integer :campaign_id
      t.integer :user_id

      t.timestamps
    end
  end
end
