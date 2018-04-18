require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  sign_in_user

  describe 'POST #create' do
    let(:valid_answer_action) do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
    end
    let(:invalid_answer_action) do
      post :create, params: { question_id: question, answer: {body: nil} }
    end

    context 'with valid attributes' do
      it 'saves new answer in DB' do
        expect { valid_answer_action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to matching question' do
        valid_answer_action
        expect(response).to redirect_to question
      end
    
      it 'associates current user with answer' do
        valid_answer_action
        expect(assigns(:answer).user_id).to eq @user.id
      end    
    end

    context 'with invalid attributes' do
      it 'doesnt save invalid answer to DB' do
        question
        expect { invalid_answer_action }.not_to change(Answer, :count)
      end

      it 'renders the new view' do
        invalid_answer_action
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'updated body' } }
      end

      it 'updates answer' do
        answer.reload
        expect(answer.body).to eq 'updated body'
      end

      it 'redirects to question' do
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, params: { question_id: question, id: answer, answer: { body: nil } }
      end

      it 'doesnt update answer' do
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 're-renders edit view' do
        expect(response).to render_template 'questions/show'
      end
    end
  end
 
  describe 'DELETE #delete' do
    before { answer }
    
    let(:delete_action) { delete :destroy, params: { question_id: answer.question.id, id: answer } }
    
    context 'deletes if request from the author' do 
      before { sign_in answer.user }
      
      it 'deletes the answer' do
        expect { delete_action }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete_action
        expect(response).to redirect_to answer.question
      end
    end
    
    context 'try to delete from not author' do
      it 'does not delete answer' do
        expect { delete_action }.not_to change(Answer, :count)
      end
      
      it 'redirects to question' do
        delete_action
        expect(response).to redirect_to answer.question
      end
    end 
  end
  

end
