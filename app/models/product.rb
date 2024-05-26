class Product < ApplicationRecord
  TAX_RATE = 0.08

  has_one_attached :image do |attachable|
    attachable.variant(:thumb, resize_to_fill: [300, 300])
  end

  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :image, presence: true

  scope :default_order, -> { order(position: :asc, id: :desc) }
  scope :published, -> { where(published: true) }

  def tax
    (self.price * TAX_RATE).floor
  end

  def price_with_tax
    price + tax
  end
end
