require 'rails_helper'

RSpec.describe 'ログイン', type: :system do
  it '正常系' do
    create(:user, email: 'kuma@test')
    visit new_user_session_path

    fill_in 'user[email]', with: 'kuma@test'
    fill_in 'user[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'ログインしました。'
  end

  it '異常系' do
    create(:user, email: 'kuma@test')
    visit new_user_session_path

    fill_in 'user[email]', with: 'yoshito@test'
    fill_in 'user[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
  end

  it '有効化していないユーザーがログインできないこと' do
    create(:user, :unconfirmed, email: 'kuma@test')
    visit new_user_session_path

    fill_in 'user[email]', with: 'kuma@test'
    fill_in 'user[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'メールアドレスの本人確認が必要です。'
  end
end
