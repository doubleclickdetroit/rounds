class WatchingsController < ApplicationController

  before_filter :check_for_round_id, :only => :create # [:index,:create]
  before_filter :check_for_type

  respond_to :json

  def index
    @user = current_user

    @watchings = @user.own(@watching_class).before_or_after(params)

    # todo with respond_with if at all possible
    # render 'watchings/index.json.rabl', object: @watchings
    render collection: @watchings, handlers: [:rabl], formats: [:json]
  end

  def create
    @watching = @watching_class.create(:round_id => @round_id, :user_id => current_user.id)

    # todo with respond_with if at all possible
    render 'watchings/show.json.rabl', object: @watching
  end

  def destroy
    @dont_build_subscription = true
    respond_with @watching_class.destroy(params[:id])
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

  def check_for_type
    @watching_class = params[:type].try(:constantize) || Watching
  end
end
