module Voteable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end
  
  def vote(user, vote)
    if user.author_of?(self)
      self.errors.add(:base, "Can't vote your own!")
    else  
     vote!(user, vote.to_i)
    end
  end
  
  def rating
    self.votes.reload.sum(:vote)
  end
  
  private
  
  def vote!(user, vote)
    vote_collection = self.votes.where(user: user).reload
    if vote_collection.empty?
      self.votes.new(user: user, vote: vote).save!
    else
      self.errors.add(:base, 'Already voted this!') if vote_collection.first.vote == vote
      vote_collection.first.destroy! if vote_collection.first.vote + vote == 0
    end
  end
end
