require 'rails_helper'

feature 'user sign in', %q{
  In order to get answer from community
  As an auth user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticatwed user creates question' do
    sign_in user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'question text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully added'
  end

  scenario 'Non-auth user tries to create question' do
    visit questions_path
    click_on 'Ask question'
#    save_and_open_page
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
  
  scenario 'Authenticated user creates the invalid question' do
    sign_in user
    
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: nil
    fill_in 'Body', with: nil
    click_on 'Create question'
    
    expect(page).to have_content('Form Errors')
end  
end
