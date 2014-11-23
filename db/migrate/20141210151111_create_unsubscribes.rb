class CreateUnsubscribes < ActiveRecord::Migration
  def change
    create_table :unsubscribes do |t|
      t.string :phone
      t.integer :user_id

      t.timestamps
    end
  end
end
