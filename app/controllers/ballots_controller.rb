class BallotsController < ApplicationController

  before_filter :check_for_slide_id, :only => :create # [:index,:create]

  respond_to :json


  def index
    @user = set_user(params, allow_user_id: true)

    @ballots = @user.own(Ballot).before_or_after(params)

    respond_with @ballots
  end

  def create
    respond_with Ballot.create(:vote => params[:vote], :slide_id => @slide_id, :user_id => current_user.id).to_json
  end

private
  def check_for_slide_id
    respond_with :bad_request if not @slide_id = params[:slide_id]
  end
end
