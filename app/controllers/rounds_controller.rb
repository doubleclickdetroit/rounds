class RoundsController < ApplicationController
  respond_to :json

  # todo refactor
  # todo dup'd in slides/comments
  def index
    provider, uid = params[:provider], params[:uid]
    @user_id = uid ? User.find_by_auth_provider_and_uid(provider, uid).try(:id) : current_user.id
    time     = params[:time] ? Time.parse(params[:time]) : nil

    @rounds  = Round.where(:user_id => @user_id)
    # todo slow! chain these somehow
    @rounds  = time ? @rounds.before(time).recent : @rounds.recent

    respond_with @rounds.to_json
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
