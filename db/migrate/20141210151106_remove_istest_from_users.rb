class RemoveIstestFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :istest, :boolean
  end
end
