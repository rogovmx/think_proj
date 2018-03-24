class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
       
  has_many :questions
  has_many :answers
  
  validates :email, :password, presence: true
  
  
  def author_of?(relation)  
    id == relation.try(:user_id)
  end
  
end
