class AddUseridToMessageReceives < ActiveRecord::Migration
  def change
    add_column :message_receives, :user_id, :integer
  end
end
