require 'rails_helper'

RSpec.describe 'ログイン', type: :system do
  it '正しいパスワードのときはログインできること' do
    create(:user, email: 'kuma@example.com')
    visit new_user_session_path

    fill_in 'user[email]', with: 'kuma@example.com'
    fill_in 'user[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'ログインしました。'
  end

  it '入力間違えのときはログインできないこと' do
    create(:user, email: 'kuma@example.com')
    visit new_user_session_path

    fill_in 'user[email]', with: 'yoshito@test'
    fill_in 'user[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
  end

  it '有効化していないユーザーがログインできないこと' do
    create(:user, :unconfirmed, email: 'kuma@example.com')
    visit new_user_session_path

    fill_in 'user[email]', with: 'kuma@example.com'
    fill_in 'user[password]', with: 'password'
    click_on 'ログインする'
    expect(page).to have_content 'メールアドレスの本人確認が必要です。'
  end
end
