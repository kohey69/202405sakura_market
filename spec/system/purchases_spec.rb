require 'rails_helper'

RSpec.describe 'Purchases', type: :system do
  let(:user) { create(:user) }

  it 'カート内にアイテムがない時、購入画面に遷移できないこと' do
    login_as user, scope: :user
    visit new_purchase_path

    expect(page).to have_current_path cart_path
    expect(page).to have_content 'カートに商品が入っていません'
  end

  it '配送先住所を入力すると購入確定画面に遷移できること' do
    create(:cart_item, :with_product, cart: user.cart)
    login_as user, scope: :user
    visit new_purchase_path

    fill_in 'purchase[address_name]', with: '田中 太郎'
    fill_in 'purchase[postal_code]', with: 'xxx-xxxx'
    select '兵庫県', from: 'purchase[prefecture]'
    fill_in 'purchase[city]', with: '神戸市中央区雲井通'
    fill_in 'purchase[other_address]', with: 'x丁目xx-xx'
    fill_in 'purchase[phone_number]', with: 'xxx-xxxx-xxxx'
    click_on '購入情報の確定へ'

    expect(page).to have_current_path confirm_purchases_path
    expect(page).to have_content '住所：兵庫県神戸市中央区雲井通x丁目xx-xx'
  end

  it '購入が確定するとユーザーのカートアイテムが削除されること' do
    create(:cart_item, :with_product, cart: user.cart)
    login_as user, scope: :user
    visit new_purchase_path

    fill_in 'purchase[address_name]', with: '田中 太郎'
    fill_in 'purchase[postal_code]', with: 'xxx-xxxx'
    select '兵庫県', from: 'purchase[prefecture]'
    fill_in 'purchase[city]', with: '神戸市中央区雲井通'
    fill_in 'purchase[other_address]', with: 'x丁目xx-xx'
    fill_in 'purchase[phone_number]', with: 'xxx-xxxx-xxxx'
    click_on '購入情報の確定へ'

    expect do
      click_on '購入を確定する'
    end.to change(Purchase, :count).by(1)
    expect(user.cart.cart_items.count).to eq 0
  end
end
