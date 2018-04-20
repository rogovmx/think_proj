require 'rails_helper'

feature 'User answer', %q{
  In order to exchange my knowledge
  As an authenticated user
  I wanna be able to create answers
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
    question = create(:question)
    visit question_path(question)
    fill_in 'Answer:', with: 'My test answer'
    click_on 'Post your answer'
    
    expect(page).to_not have_content 'My test answer'
  end  
  
  scenario 'authenticated user creates the invalid answer', js: true do
    question = create(:question)
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Answer:', with: 'My'
    click_on 'Post your answer'
    
    expect(page).to have_content 'Body is too short'
  end  
end
  
