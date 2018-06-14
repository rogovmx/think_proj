require_relative 'features_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  background do
    sign_in(user)
  end
  
  scenario 'User adds file when creates question' do
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'question text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
    
    expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/1/spec_helper.rb"
  end
  
  scenario 'User adds file when updates question', js: true do
    visit question_path(question)
    within '#question' do
      click_on 'Edit question'
      click_on 'Add attachment'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'
    end  
    expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/2/spec_helper.rb"
  end
  
  scenario 'user adds multiple files when creates question', js: true do
    visit new_question_path
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'
    click_on('Add attachment')
    click_on('Add attachment')
    inputs = all('input[type=file]')
    #save_and_open_page
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on('Create question')
    
    within('#question') do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
  
  scenario 'user adds multiple files when updates question', js: true do
    visit question_path(question)
    within '#question' do
      click_on 'Edit question'
      click_on 'Add attachment'
      click_on 'Add attachment'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Save'
    end  
    within('#question') do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end

