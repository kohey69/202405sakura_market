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
end
