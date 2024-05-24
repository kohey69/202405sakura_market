require 'rails_helper'

RSpec.describe '管理者', type: :system do
  it '正しいパスワードのときはログインできること' do
    create(:administrator, email: 'kuma@test')
    visit new_administrator_session_path

    fill_in 'administrator[email]', with: 'kuma@test'
    fill_in 'administrator[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'ログインしました。'
  end

  it '入力間違えのときはログインできないこと' do
    create(:administrator, email: 'kuma@test')
    visit new_administrator_session_path

    fill_in 'administrator[email]', with: 'yoshito@test'
    fill_in 'administrator[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
  end
end
