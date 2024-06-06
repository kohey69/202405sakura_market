require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '#destroy_with_transfer_cart_items_to!' do
    let(:original_cart) { create(:cart) }
    let(:destination_cart) { create(:cart) }
    let(:product) { create(:product, name: 'いちご') }
    let(:other_product) { create(:product, name: 'バナナ') }
    let(:duplicated_product) { create(:product, name: 'りんご') }

    context '移行先のカートに重複する商品のアイテムが入っていない時' do
      it '移行先のカートに移行元と同じ商品のアイテムが作成され、移行元のカートは削除されること' do
        create(:cart_item, :with_cart, :with_product, product:, cart: original_cart)
        create(:cart_item, :with_cart, :with_product, product: other_product, cart: destination_cart)
        original_cart.destroy_with_transfer_cart_items_to!(destination_cart)

        expect(CartItem.count).to eq 2
        expect(destination_cart.reload.cart_items.pluck(:product_id)).to contain_exactly(product.id, other_product.id)
        expect(original_cart.destroyed?).to eq true
      end
    end

    context '移行先のカートに重複する商品のアイテムが入っている時' do
      it '移行先のカートに移行元と同じ商品のアイテムは移行先そのまま残っていること' do
        create(:cart_item, :with_cart, :with_product, product:, quantity: 1, cart: original_cart)
        create(:cart_item, :with_cart, :with_product, product: duplicated_product, quantity: 2, cart: original_cart)
        create(:cart_item, :with_cart, :with_product, product: other_product, quantity: 3, cart: destination_cart)
        create(:cart_item, :with_cart, :with_product, product: duplicated_product, quantity: 4, cart: destination_cart)
        original_cart.destroy_with_transfer_cart_items_to!(destination_cart)

        expect(CartItem.count).to eq 3
        expect(destination_cart.reload.cart_items.pluck(:product_id)).to contain_exactly(product.id, duplicated_product.id, other_product.id)
        expect(destination_cart.cart_items.pluck(:quantity)).to contain_exactly(1, 3, 4)
        expect(original_cart.destroyed?).to eq true
      end
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
