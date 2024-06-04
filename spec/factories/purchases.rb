FactoryBot.define do
  factory :purchase do
    user { nil }
    total_payment { 1 }
    total_price { 1 }
    total_tax { 1 }
    cod_fee { 1 }
    shipping_fee { 1 }
    address_name { "MyString" }
    postal_code { "MyString" }
    prefecture { "MyString" }
    city { "MyString" }
    address_line { "MyString" }
  end
end
