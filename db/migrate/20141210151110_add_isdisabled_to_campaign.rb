class AddIsdisabledToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :isdisabled, :boolean, default: false
  end
end
