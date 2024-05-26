FactoryBot.define do
  factory :product do
    name { 'いちご' }
    price { '400' }
    description { '甘いいちご。芳醇な香りとこく。' }
    published { true }

    trait :unpublished do
      published { false }
    end
  end
end
