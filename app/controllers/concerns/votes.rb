module Votes 
  extend ActiveSupport::Concern
  
  def vote
    set_voteable
    @voteable.vote(current_user, params[:value])
    respond_to do |format|
      if @voteable.errors.any?
        format.json { render json: @voteable.errors.full_messages, status: :unprocessable_entity }
      else
        format.json { render json: { id: @voteable.id, rating: @voteable.rating}}
      end
    end
  end
  
  private 
  
  def model_klass
    controller_name.classify.constantize
  end
  
  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end