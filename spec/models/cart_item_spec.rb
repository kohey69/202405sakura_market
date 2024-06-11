require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe '#price' do
    it '１商品の税抜金額合計を返すこと' do
      product = create(:product, price: 120)
      cart_item = create(:cart_item, :with_cart, product:, quantity: 3)

      expect(cart_item.price).to eq 360
    end
  end
end
