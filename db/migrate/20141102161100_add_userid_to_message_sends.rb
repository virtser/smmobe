class AddUseridToMessageSends < ActiveRecord::Migration
  def change
    add_column :message_sends, :user_id, :integer
  end
end
