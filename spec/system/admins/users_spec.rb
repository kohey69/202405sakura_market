require 'rails_helper'

RSpec.describe 'ユーザー管理', type: :system do
  it 'emailを変更するとアカウント有効化のメールが送信されること' do
    user = create(:user, email: 'kuma@test')
    admin = create(:administrator)
    login_as admin, scope: :administrator
    visit edit_admins_user_path(user)

    fill_in 'user[email]', with: 'kumagai@test'
    expect do
      click_on '更新する'
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect(page).to have_content '更新しました'

    mail = ActionMailer::Base.deliveries.last

    expect(mail.to).to eq ['kumagai@test']
    expect(mail.from).to eq ['noreply@sakuramarket.jp']
    expect(mail.subject).to eq 'アカウントの有効化について'
    expect(mail.body).to match 'アカウントを有効化する'
  end
end
