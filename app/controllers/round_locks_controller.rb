class RoundLocksController < ApplicationController
  before_filter :check_for_round_id # , :only => :create # [:index,:create]

  respond_to :json

  def show
    @round_lock = RoundLock.find_by_round_id(@round_id)

    @build_subscription = true # used in rabl for PrivatePub
    # todo respond_with instead of render
    render 'round_locks/show.json.rabl', object: @round_lock
  end

  def create
    # todo .find_or_create_by_round_id instead?
    lock = RoundLock.find_by_round_id(@round_id)
    head :locked and return if lock

    respond_with RoundLock.create(:round_id => @round_id, :user_id => current_user.id)
  end

  def destroy
    @round_lock = RoundLock.find_by_round_id(@round_id)

    respond_with @round_lock.user_id == current_user.id ? @round_lock.destroy : :unauthorized
  end

private
  def check_for_round_id
    head :not_acceptable unless @round_id = params[:round_id]
  end

rescue ActionView::MissingTemplate => e
  render 'home/index'
end
