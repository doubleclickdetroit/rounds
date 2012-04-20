class RoundsController < ApplicationController
  before_filter :check_for_group_id, :only => [:index,:create]

  before_filter :authenticate_user!

  respond_to :json

  def index
    @rounds = Group.find(@group_id).rounds
    respond_with @rounds.to_json
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

private
  def check_for_group_id
    if not @group_id = params[:group_id]
      respond_with :bad_request
    else
      params[:round][:group_id] = @group_id if params[:round]
    end
  end
end
