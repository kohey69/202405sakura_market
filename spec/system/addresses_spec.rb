require 'rails_helper'

RSpec.describe 'Addresses', type: :system do
  it '既存の住所が登録済みの時、newページに遷移せずshowにリダイレクトされること' do
    user = create(:user)
    create(:address, :with_user, user:)
    login_as user, scope: :user
    visit new_address_path

    expect(page).to have_current_path address_path
  end
end
