require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { question.answers.create(attributes_for(:answer)) }

  describe 'GET #new' do
    before { get :new, params: {  question_id: question.id } }

    it 'assigns appropriate @question variable to make new answer' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new Answer to @answer variable' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'is associated with @question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:valid_answer_action) do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
    end
    let(:invalid_answer_action) do
      post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
    end

    context 'with valid attributes' do
      it 'saves new answer in DB' do
        expect { valid_answer_action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to matching question' do
        valid_answer_action
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save invalid answer to DB' do
        expect { invalid_answer_action }.not_to change(Answer, :count)
      end

      it 'renders the new view' do
        invalid_answer_action
        expect(response).to render_template :new
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
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }
    
    it 'deletes the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to question
    end
end  

end
