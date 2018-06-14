class Question < ApplicationRecord
  has_many :answers, -> { order_by_best }, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, presence: true
  
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

end
