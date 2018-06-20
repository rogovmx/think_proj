class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:voteable_id, :voteable_type]}
  validates_inclusion_of :vote, in: [-1, 1]
end
