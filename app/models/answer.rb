class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true, length: { minimum: 3 }
  
  scope :order_by_best, -> { order best: :desc }
  
  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      self.update!(best: true)
    end
  end
  
end
