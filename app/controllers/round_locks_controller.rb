class RoundLocksController < ApplicationController
  before_filter :check_for_round_id # , :only => :create # [:index,:create]

  respond_to :json

  def show
    @round_lock = RoundLock.find_by_round_id(@round_id)

    @build_subscription = true # used in rabl for PrivatePub
    # todo respond_with instead of render
    render 'round_locks/show'
  end

  def create
    # todo .find_or_create_by_round_id instead?
    lock = RoundLock.find_by_round_id(@round_id)
    head :locked and return if lock

    respond_with RoundLock.create(:round_id => @round_id, :user_id => current_user.id).to_json
  end

  def destroy
    respond_with RoundLock.find_by_round_id(@round_id).destroy.to_json
  end

private
  def check_for_round_id
    respond_with :bad_request unless @round_id = params[:round_id]
  end
end
