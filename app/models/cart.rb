class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy

  validates :user_id, uniqueness: true, allow_nil: true

  def transfer_cart_items_from!(session_cart)
    transaction do
      if cart_items.present?
        destroy_duplicated_cart_items!(session_cart)
      end
      session_cart.cart_items.each { |cart_item| cart_item.update!(cart_id: id) }
    end
  end

  def destroy_duplicated_cart_items!(session_cart)
    cart_item_product_ids = cart_items.select(:product_id)
    session_cart.cart_items.where(product_id: cart_item_product_ids).find_each(&:destroy!)
  end
end
