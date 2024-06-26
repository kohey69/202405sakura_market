require 'rails_helper'

RSpec.describe 'Purchases', type: :system do
  let(:user) { create(:user) }

  describe '購入作成から確定まで' do
    it 'カート内にアイテムがない時、購入画面に遷移できないこと' do
      login_as user, scope: :user
      visit new_purchase_path

      expect(page).to have_current_path cart_path
      expect(page).to have_content 'カートに商品が入っていません'
    end

    it '配送先住所を入力すると購入確定画面に遷移できること' do
      travel_to '2024-04-01'
      create(:cart_item, :with_product, cart: user.cart)
      login_as user, scope: :user
      visit new_purchase_path

      fill_in 'purchase[delivery_on]', with: '2024-04-04'.to_date
      select '8時〜12時', from: 'purchase[delivery_time_slot]'
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
      travel_to '2024-04-01'
      create(:cart_item, :with_product, cart: user.cart)
      login_as user, scope: :user
      visit new_purchase_path

      fill_in 'purchase[delivery_on]', with: '2024-04-04'.to_date
      select '8時〜12時', from: 'purchase[delivery_time_slot]'
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

    context 'ユーザーが住所を登録しているとき' do
      before do
        create(:address, user:, name: '田中太郎',
                         postal_code: '888-8888',
                         prefecture: '兵庫県',
                         city: '中央区雲井通',
                         other_address: '3-1-8 ソニックレジデンス808号室',
                         phone_number: '090-xxxx-xxxx')
      end

      it 'フォームの初期値に登録した住所が表示されていること', :js do
        create(:cart_item, :with_product, cart: user.cart)
        login_as user, scope: :user
        visit new_purchase_path

        expect(page).to have_field('宛名', with: '田中太郎')
        expect(page).to have_field('郵便番号', with: '888-8888')
        expect(page).to have_field('都道府県', with: '兵庫県')
        expect(page).to have_field('市区町村', with: '中央区雲井通')
        expect(page).to have_field('その他住所', with: '3-1-8 ソニックレジデンス808号室')
        expect(page).to have_field('連絡先電話番号', with: '090-xxxx-xxxx')
      end
    end
  end

  describe '購入履歴画面' do
    let(:product) { create(:product, name: 'いちご', price: '400') }

    before do
      travel_to('2024-04-01') do
        purchase = create(:purchase, user:, total_payment: 1422, total_price: 400, total_tax: 122, cod_fee: 300, shipping_fee: 600)
        create(:purchase_item, purchase:, product:, product_name: 'いちご', product_price: 400, quantity: 1)
      end
      login_as user, scope: :user
      visit purchases_path
    end

    it '購入履歴画面が表示できること' do
      expect(page).to have_content '注文履歴'
      expect(page).to have_content '購入日時: 2024年04月01日(月) '
      expect(page).to have_content '支払い総額(税込): 1,422円'
      expect(page).to have_content '商品合計額(税抜): 400円'
      expect(page).to have_content '消費税額: 122円'
      expect(page).to have_content '代引き手数料: 300円'
      expect(page).to have_content '配送手数料: 600円'
      expect(page).to have_content 'いちご'
      expect(page).to have_content '単価： 400'
      expect(page).to have_content '数量： 1'
    end

    context '商品の情報が変更された時' do
      before do
        product.update!(name: 'とちおとめ', price: 800)
      end

      it '購入時の商品名・単価が表示されること' do
        expect(page).to have_content 'いちご'
        expect(page).to have_content '単価： 400'
        expect(page).to have_content '数量： 1'
      end
    end
  end
end
