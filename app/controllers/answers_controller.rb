class AnswersController < ApplicationController
  include Votes
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:update, :edit, :destroy, :set_best, :vote]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      flash.now[:notice] = "Cant edit answer if not author"
    end
  end

  def destroy
    if current_user.author_of?(@answer)
     @answer.destroy
    else 
     flash.now[:notice] = "Cant delete answer if not author"
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.set_best
      @answers = @answer.question.answers.reload
    else 
      flash.now[:notice] = "Cant set best answer if not author"
    end
  end
  
  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy, :id])
  end
end
