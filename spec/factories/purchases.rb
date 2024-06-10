FactoryBot.define do
  factory :purchase do
    user { nil }
    total_payment { 1100 }
    total_price { 800 }
    total_tax { 100 }
    cod_fee { 100 }
    shipping_fee { 100 }
    delivery_on { Date.current + 4.days }
    delivery_time_slot { 'from_8_to_12' }
    address_name { Faker::Name.name }
    postal_code { '651-0096' }
    prefecture { '兵庫県' }
    city { '神戸市中央区雲井通' }
    other_address { '3-2-5' }

    trait :with_user do
      user
    end
  end
end
