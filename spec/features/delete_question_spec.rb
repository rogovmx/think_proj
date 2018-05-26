require_relative 'features_helper'

feature 'delete question', %q{
  only author can delete his question
} do
  
  let(:delete_action) do
    visit question_path(@question)
    click_on 'Delete question'
  end
  
  before { @question = create(:question) }  
  
  context 'logged in user' do
    scenario 'author deletes his question' do
      @user = @question.user
      sign_in(@user)
      delete_action  
      
      expect(page).not_to have_content(@question.body)
    end
    
    scenario 'only author can see delete button' do
      @user = create(:user)
      sign_in(@user)
      visit question_path(@question)
      
      expect(page).not_to have_content 'Delete question'
    end
  end
  
  context 'not logged in user' do
    scenario 'not logged in user cannot see delete button' do
      @question = create(:question)
      visit question_path(@question)
      
      expect(page).not_to have_content 'Delete question'
    end
  end
end
