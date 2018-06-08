require_relative 'features_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  background do
    sign_in(user)
    visit question_path(question)
  end
  
  scenario 'User adds file when creates answer', js: true do
    fill_in 'Answer:', with: 'My test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post your answer'
    
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/1/spec_helper.rb"
    end  
  end
  
  scenario 'User adds file when updates answer', js: true do
    fill_in 'Answer:', with: 'My test answer'
    click_on 'Post your answer'
    
    within '.answers' do
      click_on 'Edit answer'
      fill_in 'Edit your answer:', with: 'New test answer body', match: :first
      click_on 'Add attachment'

      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'
    
      expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/1/spec_helper.rb"
    end  
  end
  
  scenario 'User adds multiple files when creates answer', js: true do
    fill_in 'Answer:', with: 'My test answer'
    click_on 'Add attachment'
    inputs = all('input[type=file]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Post your answer'
    
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end  
  end  
  
  scenario 'User adds multiple files when updates answer', js: true do
    fill_in 'Answer:', with: 'My test answer'
    click_on 'Post your answer'
    
    within '.answers' do
      click_on 'Edit answer'
      fill_in 'Edit your answer:', with: 'New test answer body', match: :first
      click_on 'Add attachment'
      click_on 'Add attachment'
      inputs = all('input[type=file]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Save'
    
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end  
  end  
  
end
