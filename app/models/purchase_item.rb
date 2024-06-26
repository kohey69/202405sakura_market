class PurchaseItem < ApplicationRecord
  belongs_to :purchase
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_name, presence: true
end
