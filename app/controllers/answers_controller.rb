class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:update, :edit, :destroy, :set_best]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      @answer.errors.add(:base, message: "Cant edit answer if not author")
    end
  end

  def destroy
    if current_user.author_of?(@answer)
     @answer.destroy
    else 
     @answer.errors.add(:base, message: "Cant delete answer if not author")
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.set_best
      @answers = @answer.question.answers.reload
    else 
      @answer.errors.add(:base, message: "Cant set best answer if not author")
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
    params.require(:answer).permit(:body)
  end
end
