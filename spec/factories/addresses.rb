FactoryBot.define do
  factory :address do
    user
    name { '熊谷 康平' }
    postal_code { '888-8888' }
    prefecture { '兵庫県' }
    city { '中央区雲井通' }
    other_address { '3-1-8 ソニックレジデンス808号室' }
    phone_number { '090-xxxx-xxxx' }
  end
end
