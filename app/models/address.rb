class Address < ApplicationRecord
  POSTAL_CODE_REGEX = /\A\d{3}-?\d{4}\z/

  belongs_to :user

  validates :postal_code, format: { with: POSTAL_CODE_REGEX }, allow_blank: true
  validates :prefecture, presence: true
  validates :prefecture, inclusion: { in: JpPrefecture::Prefecture.all.map(&:name) }, if: :prefecture_changed? # prefectureがpresence: trueの時にinclusionのバリデーションをかけるため
  validates :city, presence: true
  validates :other_address, presence: true
end
