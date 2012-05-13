class CommentsController < ApplicationController
  before_filter :check_for_slide_id, :only => :create # [:index,:create]

  before_filter :authenticate_user!

  respond_to :json

  # todo refactor
  def index
    if slide_id = params[:slide_id]
      @comments = Slide.find(slide_id).comments
    else
      @comments = Comment.where(:fid => current_user.fid)
      if time = params[:time]
        time = Time.parse params[:time]
        @comments = @comments.before(time).recent
      else
        @comments = @comments.recent
      end
    end
    respond_with @comments.to_json
  end

  def create
    params[:comment][:fid] = current_user.fid
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
