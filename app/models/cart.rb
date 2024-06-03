class Cart < ApplicationRecord
  SHIPPING_FEE_PER_PRODUCT_COUNT = 600
  PRODUCT_COUNT = 5
  FEE_TAX_RATE = 0.1

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

  def total_payment
    total_price + total_tax + cod_fee + shipping_fee
  end

  def total_price
    cart_items.sum(&:price)
  end

  def total_tax
    ((total_price * Product::TAX_RATE) + ((cod_fee + shipping_fee) * FEE_TAX_RATE)).to_i
  end

  def cod_fee
    case total_price
    when 0
      0
    when 1..9999
      300
    when 10000..29999
      400
    when 30000..99999
      600
    else
      1000
    end
  end

  def shipping_fee
    return 0 if cart_items.count == 0

    ((cart_items.count / PRODUCT_COUNT) + 1) * SHIPPING_FEE_PER_PRODUCT_COUNT
  end
end
