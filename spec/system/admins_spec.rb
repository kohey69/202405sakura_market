require 'rails_helper'

RSpec.describe '管理者', type: :system do
  it '正しいパスワードのときはログインできること' do
    create(:administrator, email: 'kuma@example.com')
    visit new_administrator_session_path

    fill_in 'administrator[email]', with: 'kuma@example.com'
    fill_in 'administrator[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'ログインしました。'
  end

  it '入力間違えのときはログインできないこと' do
    create(:administrator, email: 'kuma@example.com')
    visit new_administrator_session_path

    fill_in 'administrator[email]', with: 'yoshito@test'
    fill_in 'administrator[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
  end

  it '商品マスタを作成できること' do
    admin = create(:administrator, email: 'kuma@example.com')
    login_as admin, scope: :administrator
    visit new_admins_product_path

    fill_in 'product[name]', with: 'いちご'
    fill_in 'product[price]', with: '100'
    attach_file(file_fixture('images/strawberry.jpg'))
    expect do
      click_on '登録する'
    end.to change(Product, :count).by(1)
    expect(page).to have_content '新規登録しました'
  end
end
