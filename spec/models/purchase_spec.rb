require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe '#save_with_purchase_items!' do
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
      purchase.save_with_purchase_items!
    end

    it '購入明細が同時に作成されること' do
      expect(purchase.purchase_items.count).to eq 1
      expect(purchase.purchase_items.first.product_name).to eq 'いちご'
      expect(purchase.purchase_items.first.quantity).to eq 3
    end
  end
end
