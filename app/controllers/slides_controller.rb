class SlidesController < ApplicationController

  before_filter :check_for_round_id, :only => :create # [:index,:create]
  before_filter :check_for_type, :only => [:create,:feed,:community,:friends,:private]
  before_filter :force_current_user_id, :only => :create
  
  respond_to :json


  def index
    if round_id = params[:round_id]
      @slides = Round.find(round_id).slides
    else
      @user = set_user(params, allow_user_id: true)

      @slides = @user.own(Slide).before_or_after(params)
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

  # def update
  #   respond_with Slide.update(params[:id],params[:slide]).to_json
  # end

  def destroy
    respond_with Slide.destroy(params[:id]).to_json
  end


  # RESTless
  # todo not real DRY
  def feed
    # todo dangerous?
    klass = @type.constantize

    @community_slides = current_user.community(klass)
    @friends_slides   = current_user.friends(klass)
    @private_slides   = current_user.private(klass)

    # respond_with klass.feed(current_user).to_json
    respond_with 'slides/feed'
  end

  def community
    @slides = current_user.community(@type.constantize).before_or_after(params)

    render 'slides/index' 
  end

  def friends
    @slides = current_user.friends(@type.constantize).before_or_after(params)

    # super explicit to unbreak specs
    render 'slides/index', collection: @watchings, handlers: [:rabl], formats: [:json]
  end

  def private
    @slides = current_user.private(@type.constantize).before_or_after(params)

    render 'slides/index' 
  end


private
  def check_for_round_id
    # todo ?
    if not @round_id = params[:round_id] || params[:slide].try(:[], :round_id)
      head :not_acceptable
    else
      params[:slide][:round_id] ||= @round_id if params[:slide]
    end
  end

  def check_for_type
    # todo this with .constantize? 
    if not @type = params[:type] || params[:slide].try(:[], :type)
      head :not_acceptable
    else
      params[:slide][:type] ||= @type if params[:slide]
    end
  end

  def force_current_user_id
    params[:slide][:user_id] = current_user.id
  end
end
