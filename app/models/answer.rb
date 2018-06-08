class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  
  validates :body, presence: true, length: { minimum: 3 }
  
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
  
  scope :order_by_best, -> { order best: :desc }
  
  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      self.update!(best: true)
    end
  end
  
end
