require_relative 'features_helper'

feature 'Create answer', %q{
  User can create answer while in question page
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  scenario 'authenticated user creates the answer', js: true do
    sign_in(user)
    visit question_path(question)
    
    fill_in 'Answer:', with: 'My test answer'
    click_on 'Post your answer'
    
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My test answer'
    end  
  end
  
  scenario 'unauthenticated user tries to create the answer', js: true do
#    question = create(:question)
    visit question_path(question)
    fill_in 'Answer:', with: 'My test answer'
    click_on 'Post your answer'
    
    expect(page).to_not have_content 'My test answer'
  end  
  
  scenario 'authenticated user creates the invalid answer', js: true do
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Answer:', with: 'My'
    click_on 'Post your answer'
    
    expect(page).to have_content 'Body is too short'
  end  
end
  
