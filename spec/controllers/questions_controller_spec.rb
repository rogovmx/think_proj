require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { question.user }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    
    before { get :index }
    
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
      
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
  
  describe 'GET #show' do    
    before { get :show, params: { id: question } }
    
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    
    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
  
  describe 'GET #new' do    
    sign_in_user
    
    before { get :new }
    
    it 'assigns a new Qestion to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'GET #edit' do    
    sign_in_user
    
    before { get :edit, params: { id: question } }
    
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end
  
  describe 'POST #create' do    
    sign_in_user
    
    context 'with valid attributes' do
      it 'saves the new question in the DB' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    
    it 'associates current user with question' do
      post :create, params: { question: attributes_for(:question) }
      expect(assigns(:question).user_id).to eq @user.id
    end    
    
    context 'with invalid attributes' do
      it 'doesnt save new question in the DB' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end
      
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end
  
  describe 'PATCH #update' do 
    sign_in_user
    
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end
      
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new_title', body: 'new_body' } }
        question.reload
        expect(question.title).to eq 'new_title'
        expect(question.body).to eq 'new_body'
      end
      
      it 'redirects to the updated questioin' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end
    
    context 'invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new_title', body: nil } } }
      
      it 'doesnt change question attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
      
      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end
  
  describe 'DELETE #delete' do
    let(:delete_action) { delete :destroy, params: { id: question } }
    before { question }
    
    context 'deletes if request from author' do
      before { sign_in question.user }
      
      it 'deletes the question' do
        expect { delete_action }.to change(Question, :count).by(-1)
      end

      it 'redirects to index of questions' do
        delete_action
        expect(response).to redirect_to questions_path
      end
    end
    
    context 'delete request from not author' do
      sign_in_user
      it 'does not delete question' do
        expect { delete_action }.not_to change(Question, :count)
      end
    end
  end
end
