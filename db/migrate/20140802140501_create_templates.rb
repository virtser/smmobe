class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.string :text
      t.string :image
      t.string :url

      t.timestamps
    end
  end
end
