class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :organization_id
      t.string :name
      t.string :phone
      t.string :city
      t.string :custom1
      t.string :custom2
      t.string :custom3

      t.timestamps
    end
  end
end
