require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question_with_answers) }
  let(:valid_attributes) { attributes_for(:question) }
  let(:invalid_attributes) { attributes_for(:invalid_question) }  
  let(:user) { question.user }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
   
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
       
    it 'builds new attachment for answer field' do
      expect(assigns(:question))
    end    
    
    it 'sorts the best answer first' do
      question.answers[2].set_best 
      
      expect(assigns(:answers).first.best).to eq true
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
       
    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end
    
    it 'renders new view' do
      expect(response).to render_template :new
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
    let(:update_action) do
      patch :update, params: { id: question, question: { title: 'updated title', body: 'updated body' }, format: :js }
    end

    context 'logged in user' do
      before { sign_in question.user }

      describe 'update with valid attributes' do
        before { update_action }
        
        it 'assigns to @question appropriate question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question with given attributes' do
          question.reload
          expect(question.title).to eq('updated title')
          expect(question.body).to eq('updated body')
        end

        it 'renders update template' do
          expect(response).to render_template 'update'
        end
      end
  
      describe 'update with invalid attributes' do
        before { patch :update, params: { id: question, question: invalid_attributes, format: :js } }

        it 'does not update question title with invalid attributes' do
          question.reload
          expect(question.title).to eq question.title
        end
        
        it 'does not update question body with invalid attributes' do
          question.reload
          expect(question.body).to eq question.body
        end

        it 'renders template update' do
          expect(response).to render_template 'update'
        end
      end
    end      

    context 'not author user' do
      sign_in_user
      before { update_action }
      
      it 'does not update question from not author' do
        question.reload
        expect(question.body).to eq 'MyText'
      end

      it 'renders update js' do
        expect(response).to render_template 'update'
      end
    end    

    context 'not authenticated user' do
      before { update_action }
      
      it 'does not update question' do
        expect(question.body).to eq 'MyText'
      end
      
      it 'response unauthorised' do
        expect(response.status).to eq (401)
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
