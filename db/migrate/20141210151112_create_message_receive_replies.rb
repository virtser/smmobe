class CreateMessageReceiveReplies < ActiveRecord::Migration
  def change
    create_table :message_receive_replies do |t|
      t.integer :campaign_id, null: false
      t.string :response
      t.string :reply
      t.integer :level

      t.timestamps
    end
  end
end
