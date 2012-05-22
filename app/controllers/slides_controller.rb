class SlidesController < ApplicationController

  before_filter :check_for_round_id, :only => :create # [:index,:create]
  before_filter :check_for_type, :only => [:create,:feed,:community,:friends]
  before_filter :force_current_user_id, :only => :create
  
  respond_to :json


  # todo refactor
  # todo DRY up, repeated in rounds/comments
  def index
    if round_id = params[:round_id]
      @slides = Round.find(round_id).slides
    else
      provider, uid = params[:provider], params[:uid]
      @user_id = uid ? User.find_by_auth_provider_and_uid(provider, uid).try(:id) : current_user.id

      @slides = Slide.where(:user_id => @user_id)
      if time = params[:time]
        time = Time.parse params[:time]
        @slides = @slides.before(time).recent
      else
        @slides = @slides.recent
      end
    end
    respond_with @slides
  end

  def show
    @slide = Slide.find(params[:id])
    respond_with @slide
  end

  def create
    params[:slide][:user_id] = current_user.id
    respond_with Slide.create_next(params[:slide]).to_json
  end

  def update
    respond_with Slide.update(params[:id],params[:slide]).to_json
  end

  def destroy
    respond_with Slide.destroy(params[:id]).to_json
  end


  # RESTless
  def feed
    # todo dangerous?
    @community_slides = @type.constantize.recent
    @friends_slides   = [] # @type.constantize.friends(current_user.friends_user_ids).recent
    respond_with @type
  end

  def community
    @slides = Slide.of_type_and_before(@type,params[:time])
    respond_with @slides
  end

  def friends
    @slides = [] # Slide.friends(current_user.friends_user_ids).of_type_and_before(@type,params[:time])
    respond_with @slides
  end


private
  def check_for_round_id
    # todo ?
    if not @round_id = params[:round_id] || params[:slide].try(:[], :round_id)
      respond_with :bad_request
    else
      params[:slide][:round_id] ||= @round_id if params[:slide]
    end
  end

  def check_for_type
    # todo this with .constantize? 
    if not @type = params[:type] || params[:slide].try(:[], :type)
      respond_with :bad_request
    else
      params[:slide][:type] ||= @type if params[:slide]
    end
  end

  def force_current_user_id
    params[:slide][:user_id] = current_user.id
  end
end
