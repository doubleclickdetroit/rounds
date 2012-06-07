class RoundsController < ApplicationController
  respond_to :json

  def index
    @user = set_user(params, allow_user_id: true)

    @rounds = @user.own(Round).before_or_after(params)

    respond_with @rounds
  end

  def show
    respond_with Round.find(params[:id]).to_json
  end

  # todo refactor
  def create
    @round = Round.create(user: current_user, slide_limit: 7)
    @round.round_lock = RoundLock.create(:user_id => current_user.id)
    respond_with @round.to_json
  end

  def destroy
    @round = Round.find(params[:id])
    # todo not 401
    @round.slides.empty? ? respond_with(@round.destroy) : head(401)
  end

end
