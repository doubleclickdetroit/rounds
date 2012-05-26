class CommentsController < ApplicationController
  before_filter :check_for_slide_id, :only => :create # [:index,:create]

  respond_to :json

  def index
    if slide_id = params[:slide_id]
      @comments = Slide.find(slide_id).comments
    else
      @user = params['uid'] ? User.find_by_auth_hash(params) : current_user

      @comments = @user.own(Comment).before_or_after(params)
    end

    respond_with @comments
  end

  def create
    params[:comment][:user_id] = current_user.id
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
