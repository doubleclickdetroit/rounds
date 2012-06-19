class CommentsController < ApplicationController
  before_filter :check_for_slide_id, :only => :create # [:index,:create]

  respond_to :json

  def index
    if slide_id = params[:slide_id]
      @comments = Slide.find(slide_id).comments
    else
      @user = set_user(params, allow_user_id: true)

      @comments = @user.own(Comment).before_or_after(params)
    end

    respond_with @comments
  end

  def create
    params[:comment][:user_id] = current_user.id
    respond_with Comment.create(params[:comment]).to_json
  end

  def update
    if params[:flag]
      comment = Comment.find(params[:id])
      comment.inappropriate = true
      comment.save
      respond_with comment 
    else
      respond_with Comment.update(params[:id],params[:comment]).to_json
    end
  end

  def destroy
    respond_with Comment.destroy(params[:id]).to_json
  end

private
  def check_for_slide_id
    if not @slide_id = params[:slide_id]
      head :not_acceptable
    else
      params[:comment][:slide_id] = @slide_id if params[:comment]
    end
  end
end
