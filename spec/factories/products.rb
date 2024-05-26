FactoryBot.define do
  factory :product do
    name { 'いちご' }
    price { '400' }
    description { '甘いいちご。芳醇な香りとこく。' }
    image { ActiveStorageTestHelper.create_file_blob_by_path(Rails.root.join('spec/fixtures/files/images/strawberry.jpg')) }
    published { true }

    trait :unpublished do
      published { false }
    end
  end
end
