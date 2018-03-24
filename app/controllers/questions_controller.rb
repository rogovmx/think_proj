class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  
  def index
    @questions = Question.all 
  end
  
  def show
    @answers = @question.answers
  end
  
  def new
    @question = current_user.questions.new
  end
  
  def edit
  end
  
  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully added'
    else
      render :new
    end  
  end
  
  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end  
  end
  
  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: "Question deleted"
    else
      redirect_to @question, alert: "No access to delete this question"
    end      
  end
  
  private
  
  def load_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body)
  end
  
end