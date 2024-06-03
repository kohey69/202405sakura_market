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

  describe '金額計算の境界値ユニットテスト' do
    let(:cart) { create(:cart) }

    context '商品数0・商品合計金額0の時' do
      it '正しい金額を返すこと' do
        expect(cart.total_price).to eq  0
        expect(cart.shipping_fee).to eq 0
        expect(cart.cod_fee).to eq 0
        expect(cart.total_tax).to eq 0
        expect(cart.total_payment).to eq 0
      end
    end

    context '商品数4・商品合計金額9999の時' do
      before do
        product1 = create(:product, name: 'いちご', price: 1111)
        product2 = create(:product, name: 'レモン', price: 1111)
        product3 = create(:product, name: 'バナナ', price: 1111)
        product4 = create(:product, name: 'メロン', price: 1111)
        create(:cart_item, product: product1, cart:, quantity: 1)
        create(:cart_item, product: product2, cart:, quantity: 1)
        create(:cart_item, product: product3, cart:, quantity: 1)
        create(:cart_item, product: product4, cart:, quantity: 6)
      end

      it '正しい金額を返すこと' do
        expect(cart.total_price).to eq 9999
        expect(cart.shipping_fee).to eq 600
        expect(cart.cod_fee).to eq 300
        expect(cart.total_tax).to eq 799 + 90
        expect(cart.total_payment).to eq 9999 + 600 + 300 + 799 + 90
      end
    end

    context '商品数6・商品合計金額10000の時' do
      before do
        product1 = create(:product, name: 'いちご', price: 1000)
        product2 = create(:product, name: 'レモン', price: 1000)
        product3 = create(:product, name: 'バナナ', price: 1000)
        product4 = create(:product, name: 'メロン', price: 1000)
        product5 = create(:product, name: 'スイカ', price: 1000)
        create(:cart_item, product: product1, cart:, quantity: 1)
        create(:cart_item, product: product2, cart:, quantity: 1)
        create(:cart_item, product: product3, cart:, quantity: 1)
        create(:cart_item, product: product4, cart:, quantity: 1)
        create(:cart_item, product: product5, cart:, quantity: 6)
      end

      it '正しい金額を返すこと' do
        expect(cart.total_price).to eq 10000
        expect(cart.shipping_fee).to eq 1200
        expect(cart.cod_fee).to eq 400
        expect(cart.total_tax).to eq 800 + 160
        expect(cart.total_payment).to eq 10000 + 1200 + 400 + 800 + 160
      end
    end
  end
end
