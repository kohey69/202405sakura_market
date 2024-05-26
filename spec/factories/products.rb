FactoryBot.define do
  factory :product do
    name { 'いちご' }
    price { '400' }
    description { '甘いいちご。芳醇な香りとこく。' }
    image { Rack::Test::UploadedFile.new('spec/fixtures/files/images/strawberry.jpg') }
    published { true }

    trait :unpublished do
      published { false }
    end
  end
end
