class Cart < ApplicationRecord
  SHIPPING_FEE_PER_PRODUCTS_SET = 600
  PRODUCTS_SET_SIZE = 5
  FEE_TAX_RATE = 0.1

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
    return 0 if cart_items.count.zero?

    ((cart_items.count / PRODUCTS_SET_SIZE) + 1) * SHIPPING_FEE_PER_PRODUCTS_SET
  end
end
