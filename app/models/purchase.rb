class Purchase < ApplicationRecord
  belongs_to :user
  has_many :purchase_items, dependent: :destroy

  validates :total_payment, presence: true
  validates :total_price, presence: true
  validates :total_tax, presence: true
  validates :cod_fee, presence: true
  validates :shipping_fee, presence: true
  validates :prefecture, presence: true, inclusion: { in: JpPrefecture::Prefecture.all.map(&:name) }
  validates :city, presence: true
  validates :other_address, presence: true

  after_create :destroy_cart_items!

  def assign_cart_attributes
    self.total_payment = user.cart.total_payment
    self.total_price = user.cart.total_price
    self.total_tax = user.cart.total_tax
    self.cod_fee = user.cart.cod_fee
    self.shipping_fee = user.cart.shipping_fee
  end

  def save_with_purchase_items!
    transaction do
      self.user.cart.cart_items.each do |cart_item|
        purchase_item = self.purchase_items.build
        purchase_item.product_name = cart_item.product.name
        purchase_item.product_id = cart_item.product_id
        purchase_item.quantity = cart_item.quantity
      end
      self.save!
    end
  end

  def destroy_cart_items!
    self.user.cart.cart_items.destroy_all
  end
end
