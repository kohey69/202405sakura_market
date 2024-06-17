require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#published' do
    it '公開中の商品のARオブジェクトが返されること' do
      create(:product, published: true, name: '公開中の商品')
      create(:product, :unpublished, name: '非公開の商品')

      expect(Product.published.pluck(:name)).to contain_exactly('公開中の商品')
    end
  end

  describe '#tax' do
    it '税率が8%で小数点以下の金額が切り捨てられていること' do
      product = create(:product, price: '110')
      expect(product.tax).not_to eq 8.8
      expect(product.tax).to eq 8
    end
  end

  describe '#price_with_tax' do
    it '消費税込みの金額が返されること' do
      product = create(:product, price: '110')
      expect(product.price_with_tax).to eq 118
    end
  end
end
