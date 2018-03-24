require 'rails_helper'

feature 'user sign in', %q{
  In order to be able to ask question
  As in user
  Iwant to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in user

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registred user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end

feature 'User log out', %q{
  In order to able end session user can be able
  to log-out
} do
  given(:user) { create(:user) }

  scenario 'Logged-in user clicks logout button' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
