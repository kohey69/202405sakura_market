class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :name, null: false, default: '', comment: '宛名'
      t.string :postal_code, null: false, default: ''
      t.string :prefecture, null: false
      t.string :city, null: false
      t.string :other_address, null: false, comment: '丁目・番地・建物名'
      t.string :phone_number, null: false, default: ''
      t.timestamps
    end
  end
end
