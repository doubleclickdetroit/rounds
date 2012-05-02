class RoundLocksController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def show
    respond_with RoundLock.find(params[:id]).to_json
  end

  def create
    respond_with RoundLock.create(params[:round_lock]).to_json
  end

  def destroy
    respond_with RoundLock.destroy(params[:id]).to_json
  end

end
