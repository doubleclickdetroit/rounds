class RoundsController < ApplicationController
  respond_to :json

  def index
    @user = params['uid'] ? User.find_by_auth_hash(params) : current_user

    @rounds = @user.own(Round).before_or_after(params)

    respond_with @rounds
  end

  def show
    respond_with Round.find(params[:id]).to_json
  end

  # todo refactor
  def create
    @round = Round.create(:user_id => current_user.id)
    @round.round_lock = RoundLock.create(:user_id => current_user.id)
    respond_with @round.to_json
  end

  # def update
  #   respond_with Round.update(params[:id],params[:round]).to_json
  # end

  def destroy
    @round = Round.find(params[:id])
    # todo not 401
    @round.slides.empty? ? respond_with(@round.destroy) : head(401)
  end

end
