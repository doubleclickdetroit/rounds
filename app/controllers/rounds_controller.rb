class RoundsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  # todo refactor
  def index
    time    = params[:time] ? Time.parse(params[:time]) : nil
    @rounds = Round.where(:fid => current_user.fid)
    @rounds = time ? @rounds.before(time).recent : @rounds.recent
    respond_with @rounds.to_json
  end

  def show
    respond_with Round.find(params[:id]).to_json
  end

  # todo refactor
  def create
    @round = Round.create(:fid => current_user.fid)
    @round.round_lock = RoundLock.create(:fid => current_user.fid)
    respond_with @round.to_json
  end

  # def update
  #   respond_with Round.update(params[:id],params[:round]).to_json
  # end

  def destroy
    respond_with Round.destroy(params[:id]).to_json
  end

end
