require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe '#purchase_and_destroy_cart_items!' do
    let(:user) { create(:user) }
    let(:product) { create(:product, name: 'いちご') }
    let(:purchase) do
      build(:purchase, user:,
                       total_payment: 1100,
                       total_price: 800,
                       total_tax: 100,
                       cod_fee: 100,
                       shipping_fee: 100,
                       address_name: '田中太郎',
                       postal_code: '651-0096',
                       prefecture: '兵庫県',
                       city: '神戸市中央区雲井通',
                       other_address: '3-2-5',
                       phone_number: '090-xxxx-xxxx')
    end

    before do
      create(:cart_item, product:, cart: user.cart, quantity: 3)
      purchase.purchase_and_destroy_cart_items!
    end

    it '購入明細が同時に作成されること' do
      expect(purchase.purchase_items.count).to eq 1
      expect(purchase.purchase_items.first.product_name).to eq 'いちご'
      expect(purchase.purchase_items.first.quantity).to eq 3
    end

    it 'カート内アイテムがクリアされること' do
      expect(user.cart.cart_items.count).to eq 0
    end
  end

  describe '#delivery_on_after_three_work_days' do
    it '本日から数えて３営業日目を配送希望日に指定できないこと' do
      purchase = build(:purchase, :with_user, delivery_on: 2.business_days.from_now)

      expect(purchase.valid?).to eq false
    end

    it '本日から数えて４営業日目移行は配送希望日に指定できること' do
      purchase = build(:purchase, :with_user, delivery_on: 3.business_days.from_now)

      expect(purchase.valid?).to eq true
    end
  end
end
