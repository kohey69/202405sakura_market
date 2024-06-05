class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy

  validates :user_id, uniqueness: true, allow_nil: true

  def destroy_with_transfer_cart_items_to!(destination_cart)
    transaction do
      product_ids = destination_cart.cart_items.select(:product_id)
      cart_items.where.not(product_id: product_ids).find_each do |cart_item|
        copy_item = cart_item.dup
        copy_item.cart_id = destination_cart.id
        copy_item.save!
      end
      self.destroy!
    end
  end
end
