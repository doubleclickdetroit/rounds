class CommentsController < ApplicationController
  before_filter :check_for_slide_id, :only => [:index,:create]

  before_filter :authenticate_user!

  respond_to :json

  def index
    @comments = Slide.find(@slide_id).comments
    respond_with @comments.to_json
  end

  def create
    respond_with Comment.create(params[:comment]).to_json
  end

  def update
    respond_with Comment.update(params[:id],params[:comment]).to_json
  end

  def destroy
    respond_with Comment.destroy(params[:id]).to_json
  end

private
  def check_for_slide_id
    if not @slide_id = params[:slide_id]
      respond_with :bad_request
    else
      params[:comment][:slide_id] = @slide_id if params[:comment]
    end
  end
end
