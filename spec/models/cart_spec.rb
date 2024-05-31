require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '#transfer_cart_items_from!' do
    let(:db_cart) { create(:cart) }
    let(:session_cart) { create(:cart) }
    let(:product) { create(:product, name: 'いちご') }
    let(:other_product) { create(:product, name: 'バナナ') }
    let(:duplicated_product) { create(:product, name: 'りんご') }

    context 'sessionのカートとDBのカートの両方にアイテムが存在する時' do
      it '重複するアイテムがない時、sessionとDBのアイテムが同じカートに入れられること' do
        cart_item1 = create(:cart_item, :with_cart, :with_product, product:, cart: db_cart)
        cart_item2 = create(:cart_item, :with_cart, :with_product, product: other_product, cart: session_cart)
        db_cart.transfer_cart_items_from!(session_cart)

        expect(db_cart.reload.cart_items).to contain_exactly(cart_item1, cart_item2)
      end

      it '重複するアイテムがある時、DBのアイテムのみがカートに保存されること' do
        cart_item1 = create(:cart_item, :with_cart, :with_product, product:, cart: db_cart)
        cart_item2 = create(:cart_item, :with_cart, :with_product, product: duplicated_product, cart: db_cart)
        cart_item3 = create(:cart_item, :with_cart, :with_product, product: other_product, cart: session_cart)
        _cart_item4 = create(:cart_item, :with_cart, :with_product, product: duplicated_product, cart: session_cart)
        db_cart.transfer_cart_items_from!(session_cart)

        expect(db_cart.reload.cart_items).to contain_exactly(cart_item1, cart_item2, cart_item3)
      end
    end
  end

  describe '#destroy_duplicated_cart_items!' do
    it '重複するアイテムのみ削除されること' do
      product = create(:product, name: 'いちご')
      duplicated_product = create(:product, name: 'バナナ')
      other_product = create(:product, name: 'りんご')
      db_cart = create(:cart)
      session_cart = create(:cart)
      cart_item1 = create(:cart_item, :with_cart, :with_product, product:, cart: db_cart)
      cart_item2 = create(:cart_item, :with_cart, :with_product, product: duplicated_product, cart: db_cart)
      cart_item3 = create(:cart_item, :with_cart, :with_product, product: other_product, cart: session_cart)
      _cart_item4 = create(:cart_item, :with_cart, :with_product, product: duplicated_product, cart: session_cart)
      db_cart.destroy_duplicated_cart_items!(session_cart)

      expect(CartItem.pluck(:id)).to contain_exactly(cart_item1.id, cart_item2.id, cart_item3.id)
    end
  end
end
