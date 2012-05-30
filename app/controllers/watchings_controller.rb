class WatchingsController < ApplicationController
  before_filter :check_for_round_id, :only => :create # [:index,:create]

  respond_to :json

  def index
    @user = current_user

    @watchings = @user.own(Watching).before_or_after(params)

    respond_with @watchings
  end

  def create
    Watching.create(:round_id => @round_id, :user_id => current_user.id)

    respond_with PrivatePub.subscription channel: "/api/rounds/#{@round_id}"
  end

  def destroy
    respond_with Watching.destroy(params[:id])
  end

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
