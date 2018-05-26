require_relative 'features_helper'

feature 'update question', %q{
  to be able to correct mistakes, author can edit his question
} do
  given(:question) { create(:question) }
  given(:user) { question.user }
  
  context 'author of question' do
    before do 
      sign_in(user)
      visit question_path(question)
      click_link 'Edit question'
    end
    
    scenario 'edits and updates his question', js: true do
      fill_in 'Edit your question title:', with: 'New test question title'
      fill_in 'Edit your question:', with: 'New test text for question body'
      click_on 'Save'
      
      within('h2') { expect(page).to have_content 'New test question title' }
      within('#question p.body') { expect(page).to have_content 'New test text for question body' }
      expect(page).not_to have_content 'Save'
      expect(page).to have_content 'Edit question'
    end
    
    scenario 'tries to update his question with invalid attributes', js: true do
      fill_in 'Edit your question title:', with: ''
      fill_in 'Edit your question:', with: ''
      click_on 'Save'
    
      within('#errors') do
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content "Title can't be blank"
      end
    end
  end
  
  context 'not author of question' do
    scenario 'does not see edit question button if he is not author' do
      sign_in(create(:user))
      visit question_path(question)
      
      expect(page).not_to have_content 'Edit question'
    end
    
    scenario 'unauthenticated user does not see edit button' do
      visit question_path(question)
      
      expect(page).not_to have_content 'Edit question'
    end
  end
end
