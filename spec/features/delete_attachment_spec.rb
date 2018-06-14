require_relative 'features_helper'

feature 'it deletes question attachments', %q{
  In order to correct mistakes author able
  to delete attachment
} do
  
  given(:question) { create(:question)}
  given(:another_user) { create(:user) }
  
  background do
    sign_in question.user
    visit question_path(question)
    within('#question') do
      click_on 'Edit question'
      fill_in 'Edit your question title:', with: 'Test question'
      fill_in 'Edit your question:', with: 'question text'
      click_on 'Add attachment'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'
    end  
  end
  
  scenario 'author deletes attachment', js: true do
    within('#question') { click_on('[x]') }

    expect(page).not_to have_content('spec_helper.rb')
  end
  
  scenario 'non-author cannot see delete attachment link', js: true do
    click_on('Log out')
    sign_in another_user
    visit question_path(question)

    within('#question') do
      expect(page).not_to have_content('[x]')
    end
  end
end

feature 'it deletes answer attachments', %q{
  In order to correct mistakes author able
  to delete attachment
} do
  
  given(:question) { create(:question)}
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  
  background do
    sign_in user
    visit question_path(question)
    fill_in 'Answer:', with: 'My test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post your answer'
  end
  
  scenario 'author deletes attachment', js: true do
    within('.answers') { click_on('[x]') }

    expect(page).not_to have_content('spec_helper.rb')
  end
  
  scenario 'non-author cannot see delete attachment link', js: true do
    click_on('Log out')
    sign_in another_user
    visit question_path(question)

    within('.answers') do
      expect(page).not_to have_content('[x]')
    end
  end
end