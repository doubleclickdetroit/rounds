class RoundsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    # todo not sure if this action is needed
    @rounds = []
    respond_with @rounds.to_json
  end

  def show
    respond_with Round.find(params[:id]).to_json
  end

  def create
    respond_with Round.create(params[:round]).to_json
  end

  def update
    respond_with Round.update(params[:id],params[:round]).to_json
  end

  def destroy
    respond_with Round.destroy(params[:id]).to_json
  end

end
