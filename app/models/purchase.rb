class Purchase < ApplicationRecord
  extend Enumerize

  enumerize :delivery_time_slot, in: %i[from_8_to_12 from_12_to_14 from_14_to_16 from_16_to_18 from_18_to_20 from_20_to_21]

  belongs_to :user
  has_many :purchase_items, dependent: :destroy

  validates :total_payment, presence: true
  validates :total_price, presence: true
  validates :total_tax, presence: true
  validates :cod_fee, presence: true
  validates :shipping_fee, presence: true
  validates :delivery_on, presence: true
  validate :delivery_on_after_three_work_days
  validates :delivery_time_slot, presence: true
  validates :prefecture, presence: true, inclusion: { in: JpPrefecture::Prefecture.all.map(&:name) }
  validates :city, presence: true
  validates :other_address, presence: true

  scope :default_order, -> { order(created_at: :desc, id: :desc) }

  def delivery_on_after_three_work_days
    return if delivery_on.blank?

    if !delivery_on.workday?
      errors.add(:delivery_on, 'は営業日ではありません')
    elsif delivery_on < 3.business_days.after(Date.current)
      errors.add(:delivery_on, 'は３営業日後以降を選択してください')
    end
  end

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
