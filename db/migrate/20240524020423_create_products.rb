class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description
      t.boolean :published, null: false, default: false
      t.string :position
      t.timestamps
    end
  end
end
