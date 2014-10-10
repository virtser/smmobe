class CreateMessageSends < ActiveRecord::Migration
  def change
    create_table :message_sends do |t|
      t.string :sid
      t.datetime :date
      t.text :from_phone
      t.text :to_phone
      t.text :body
      t.text :status

      t.timestamps
    end
  end
end
