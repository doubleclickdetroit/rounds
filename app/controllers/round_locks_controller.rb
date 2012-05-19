class RoundLocksController < ApplicationController
  respond_to :json

  def show
    respond_with RoundLock.find_by_round_id(params[:round_id]).to_json
  end

  def create
    # todo .find_or_create_by_round_id instead?
    lock = RoundLock.find_by_round_id(params[:round_id])
    head :locked and return if lock

    respond_with RoundLock.create(:round_id => params[:round_id], :fid => current_user.id).to_json
  end

  def destroy
    respond_with RoundLock.find_by_round_id(params[:round_id]).destroy.to_json
  end

end
