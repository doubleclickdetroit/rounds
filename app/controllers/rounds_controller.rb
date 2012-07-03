class RoundsController < ApplicationController
  before_filter :check_for_slide_limit, only: [:create]
  before_filter :check_for_private,     only: [:create]

  respond_to :json

  def index
    @user = set_user(params, allow_user_id: true)

    @rounds = @user.own(Round).before_or_after(params)

    respond_with @rounds
  end

  def show
    @round = Round.find(params[:id])
    respond_with @round
  end

  # todo refactor
  def create
    @round = Round.create(user: current_user, slide_limit: @slide_limit, :private => @private)
    @round.round_lock = RoundLock.create(:user_id => current_user.id)
    respond_with @round.to_json
  end

  def destroy
    @round = Round.find(params[:id])
    # todo not 401
    @round.slides.empty? ? respond_with(@round.destroy) : head(401)
  end

private
  def check_for_slide_limit
    head :not_acceptable unless @slide_limit = params[:slide_limit]
  end

  def check_for_private
    @private = !!params[:private]
  end
end
