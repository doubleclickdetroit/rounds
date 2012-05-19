class BallotsController < ApplicationController
  before_filter :check_for_slide_id, :only => [:index,:create]

  respond_to :json

  def create
    respond_with Ballot.create(:vote => params[:vote], :slide_id => @slide_id, :fid => current_user.id).to_json
  end

private
  def check_for_slide_id
    respond_with :bad_request if not @slide_id = params[:slide_id]
  end
end
