class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create, :update, :destroy]
  before_action :set_answer, only: [:update, :edit, :destroy]

  def new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if @answer.update(answer_params)
      redirect_to @question, notice: "Your answer have been successfully updated"
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
     @answer.destroy
     flash[:notice] = "Answer deleted"
    else 
     flash[:alert] = "No access to delete this answer"
    end
    redirect_to @question
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
