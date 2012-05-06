class WatchingsController < ApplicationController
  before_filter :check_for_slide_id, :only => [:index,:create]

  before_filter :authenticate_user!

  respond_to :json

  def create
    respond_with Watching.create(params[:watching]).to_json
  end

  def destroy
    respond_with Watching.destroy(params[:id]).to_json
  end

private
  def check_for_slide_id
    if not @slide_id = params[:slide_id]
      respond_with :bad_request
    else
      params[:watching][:slide_id] = @slide_id if params[:comment]
    end
  end
end
