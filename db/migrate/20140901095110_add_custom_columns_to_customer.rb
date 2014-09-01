class AddUserIdToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :user_id, :integer, :null => false
  end
end
