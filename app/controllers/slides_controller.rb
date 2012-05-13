class SlidesController < ApplicationController
  before_filter :check_for_round_id, :only => :create # [:index,:create]
  before_filter :check_for_type, :only => [:create,:feed,:recent,:friends]
  before_filter :force_current_user_fid, :only => :create
  
  before_filter :authenticate_user!

  respond_to :json


  # todo refactor
  def index
    time    = params[:time] ? Time.parse(params[:time]) : nil
    @slides = Slide.where(:fid => current_user.fid)
    @slides = time ? @slides.before(time).recent : @slides.recent
    respond_with @slides.to_json
  end

  def show
    respond_with Slide.find(params[:id]).to_json
  end

  def create
    params[:slide][:fid] = current_user.fid
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
    respond_with @type.constantize.feed(current_user.friends_fids)
  end

  def recent
    @slides = Slide.of_type_and_before(@type,params[:time])
    respond_with @slides.map(&:to_hash).to_json
  end

  def friends
    @slides = Slide.friends(current_user.friends_fids).of_type_and_before(@type,params[:time])
    respond_with @slides.map(&:to_hash).to_json
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

  def force_current_user_fid
    params[:slide][:fid] = current_user.fid
  end
end
