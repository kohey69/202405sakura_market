require 'rails_helper'

RSpec.describe '商品', type: :system do
  before do
    admin = create(:administrator, email: 'kuma@test')
    login_as admin, scope: :administrator
  end

  it '管理者は商品マスタを作成できること' do
    visit new_admins_product_path

    fill_in 'product[name]', with: 'いちご'
    fill_in 'product[price]', with: '100'
    attach_file(file_fixture('images/strawberry.jpg'))
    expect do
      click_on '登録する'
    end.to change(Product, :count).by(1)
    expect(page).to have_content '新規登録しました'
  end

  it '管理者の商品一覧ページには非公開の商品含め全て表示されていること' do
    create(:product, name: 'いちご')
    create(:product, name: 'レモン')
    create(:product, :unpublished, name: 'バナナ')
    visit admins_products_path

    expect(page).to have_content 'いちご'
    expect(page).to have_content 'レモン'
    expect(page).to have_content 'バナナ'
  end

  it '管理者は商品の編集ができること' do
    product = create(:product, name: 'いちご', price: '400', description: '甘い')
    visit edit_admins_product_path(product)

    expect(page).to have_content '商品情報の編集'
    fill_in 'product[name]', with: 'とちおとめ'
    fill_in 'product[price]', with: '800'
    fill_in 'product[description]', with: '甘すぎる'
    click_on '更新する'

    expect(page).to have_content '更新しました'
    expect(product.reload.name).to eq 'とちおとめ'
    expect(product.price).to eq 800
    expect(product.description).to eq '甘すぎる'
  end
end
