FactoryBot.define do
  factory :cart_item do
    quantity { 1 }

    trait :with_cart do
      cart
    end

    trait :with_product do
      product
    end
  end
end
