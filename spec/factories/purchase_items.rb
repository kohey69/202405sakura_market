FactoryBot.define do
  factory :purchase_item do
    purchase { nil }
    product { nil }
    quantity { 1 }
    product_name { 'MyString' }

    trait :with_purchase do
      purchase
    end
  end
end
