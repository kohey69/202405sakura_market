class CreatePurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_payment, null: false, comment: '支払い総額(税込)'
      t.integer :total_price, null: false, comment: '合計(税抜)'
      t.integer :total_tax, null: false, comment: '消費税額'
      t.integer :cod_fee, null: false, comment: '代引き手数料'
      t.integer :shipping_fee, null: false, comment: '配送手数料'
      t.string :address_name, null: false, default: '', comment: '宛名'
      t.string :postal_code, null: false, default: ''
      t.string :prefecture, null: false
      t.string :city, null: false
      t.string :other_address, null: false, comment: '丁目・番地・建物名'
      t.string :phone_number, null: false, default: ''

      t.timestamps
    end
  end
end
