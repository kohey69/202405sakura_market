require 'rails_helper'

RSpec.describe 'ユーザー管理', type: :system do
  it 'メールアドレスがパスワードなしで変更できること' do
    user = create(:user, email: 'kuma@test')
    admin = create(:administrator)
    login_as admin, scope: :administrator
    visit edit_admins_user_path(user)

    fill_in 'user[email]', with: 'kuma@test'
    click_on '更新する'
    expect(page).to have_content '更新しました'
    expect(page).to have_current_path admins_users_path
  end
end
