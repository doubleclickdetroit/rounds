class WatchingsController < ApplicationController
  before_filter :check_for_round_id, :only => [:index,:create]

  before_filter :authenticate_user!

  respond_to :json

  def create
    respond_with Watching.create(:round_id => @round_id, :fid => current_user.fid).to_json
  end

  # def destroy
  #   respond_with Watching.destroy(params[:id]).to_json
  # end

private
  def check_for_round_id
    # todo || ?
    if not @round_id = params[:round_id] || params[:watching].try(:[],:round_id)
      respond_with :bad_request
    else
      params[:watching][:round_id] = @round_id if params[:watching]
    end
  end
end
