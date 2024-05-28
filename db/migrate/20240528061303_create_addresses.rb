class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user
      t.string :name, null: false, default: '', comment: '宛名'
      t.string :postal_code, null: false, default: ''
      t.string :prefecture, null: false, default: ''
      t.string :city, null: false, default: ''
      t.string :other_address, null: false, default: ''
      t.string :phone_number, null: false, default: ''
      t.timestamps
    end
  end
end
