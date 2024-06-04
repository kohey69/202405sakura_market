class CreatePurchaseItems < ActiveRecord::Migration[7.1]
  def change
    create_table :purchase_items do |t|
      t.references :purchase, null: false, foreign_key: true, index: false
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.string :product_name, null: false
      t.index %i[purchase_id product_id], unique: true

      t.timestamps
    end
  end
end
