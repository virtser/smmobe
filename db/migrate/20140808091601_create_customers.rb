class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :phone
      t.string :name
      t.integer :campaign_id

      t.timestamps
    end
  end
end
