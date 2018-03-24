require 'rails_helper'

RSpec.describe User, type: :model do
  
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  
  before do 
    @question = create(:question)
    @another_question = create(:question)
    @user = @question.user  
  end
  
  it 'has appropriate author_of? method (true condition)' do
    expect(@user.author_of?(@question)).to eq true
  end  
  
  it 'has appropriate author_of? method (false condition)' do
    expect(@user.author_of?(@another_question)).to eq false
  end 
  
  
end

