class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false, default: ''
      t.integer :price, null: false
      t.text :description, default: ''
      t.boolean :published, null: false, default: false
      t.integer :position
      t.timestamps
    end
  end
end
