class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :confirmable

  validates :name, presence: true

  scope :default_order, -> { order(id: :asc) }
end
