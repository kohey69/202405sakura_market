class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :confirmable

  has_one :address, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :purchases, dependent: :destroy

  validates :name, presence: true

  scope :default_order, -> { order(id: :asc) }

  after_create :create_cart!
end
