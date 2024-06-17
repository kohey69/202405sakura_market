FactoryBot.define do
  factory :administrator do
    email { Faker::Internet.email }
    password { 'password' }
  end
end
