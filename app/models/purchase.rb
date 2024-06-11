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

  scope :default_order, -> { order(created_at: :desc, id: :desc) }

  def assign_cart_attributes(cart)
    self.total_payment = cart.total_payment
    self.total_price = cart.total_price
    self.total_tax = cart.total_tax
    self.cod_fee = cart.cod_fee
    self.shipping_fee = cart.shipping_fee
  end

  def purchase_and_destroy_cart_items!
    transaction do
      self.user.cart.cart_items.each do |cart_item|
        purchase_item = self.purchase_items.build
        purchase_item.product_id = cart_item.product_id
        purchase_item.product_name = cart_item.product.name
        purchase_item.product_price = cart_item.product.price
        purchase_item.quantity = cart_item.quantity
      end
      self.save!
      self.user.cart.cart_items.destroy_all
    end
  end
end
