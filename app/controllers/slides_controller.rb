class SlidesController < ApplicationController
  before_filter :check_for_round_id, :only => [:index,:create]
  before_filter :check_for_type, :only => [:recent,:friends]
  
  before_filter :authenticate_user!

  respond_to :json

  def index
    @slides = Round.find(@round_id).slides
    respond_with @slides.map(&:to_hash).to_json
  end

  def show
    respond_with Slide.find(params[:id]).to_json
  end

  def create
    respond_with Slide.create(params[:slide]).to_json
  end

  def update
    respond_with Slide.update(params[:id],params[:slide]).to_json
  end

  def destroy
    respond_with Slide.destroy(params[:id]).to_json
  end


  # RESTless
  def recent
    # todo refactor ffs
    # type, time = @type, params[:time]

    # if time
    #   @slides = Slide.of_type(type).recent
    # else
    #   @slides = Slide.of_type(type).before(params[:time])
    # end

    # respond_with @slides.to_json
  end

  def friends
  end

private
  def check_for_round_id
    if not @round_id = params[:round_id]
      respond_with :bad_request
    else
      params[:slide][:round_id] = @round_id if params[:slide]
    end
  end

  def check_for_type
    respond_with :bad_request unless @type = params[:type]
  end
end
