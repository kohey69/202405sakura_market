class Product < ApplicationRecord
  PRODUCT_TAX_RATE = 0.08

  has_one_attached :image do |attachable|
    attachable.variant(:thumb, resize_to_fill: [300, 300])
  end

  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :default_order, -> { order(position: :asc, created_at: :desc) }

  def tax
    (self.price * PRODUCT_TAX_RATE).floor
  end

  def price_with_tax
    price + tax
  end
end
