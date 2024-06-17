class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :confirmable

  has_one :address, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :purchases, dependent: :destroy # userは物理削除しないので購入履歴は退会時もアプリに残る

  validates :name, presence: true

  scope :default_order, -> { order(id: :asc) }

  after_create :create_cart!

  def soft_destroy!
    self.update!(deleted_at: Time.current)
  end

  def active_for_authentication?
    super && !deleted_at
  end

  def inactive_message
    deleted_at ? :deleted_account : super
  end
end
