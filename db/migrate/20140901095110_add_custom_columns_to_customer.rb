class AddCustomColumnsToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :first_name, :string
    add_column :customers, :last_name, :string
    add_column :customers, :custom1, :string
    add_column :customers, :custom2, :string
    add_column :customers, :custom3, :string
    execute "UPDATE customers SET first_name = name"
    remove_column :customers, :name
  end
end
