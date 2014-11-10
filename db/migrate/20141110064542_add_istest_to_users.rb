class AddIstestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :istest, :boolean
  end
end
