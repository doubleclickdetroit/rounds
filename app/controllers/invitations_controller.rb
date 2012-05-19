class InvitationsController < ApplicationController
  before_filter :setup_invitation, :only => [:index,:create]
  before_filter :check_for_round_id, :only => [:index,:create]
  before_filter :check_for_invited_user_id, :only => :create
  before_filter :force_current_user_id, :only => :create
  
  respond_to :json


  def index
    @invitations = Round.find(@round_id).invitations
    respond_with @invitations.to_json
  end

  def create
    respond_with Invitation.create(@invitation).to_json
  end

  def destroy
    respond_with Invitation.destroy(params[:id]).to_json
  end


private
  def setup_invitation
    @invitation = {}
  end

  def check_for_round_id
    # todo ?
    if not @round_id = params[:round_id]
      respond_with :bad_request
    else
      @invitation[:round_id] ||= @round_id 
    end
  end

  def check_for_invited_user_id
    # todo ?
    if not @invited_user_id = params[:invited_user_id]
      respond_with :bad_request
    else
      @invitation[:invited_user_id] ||= @invited_user_id
    end
  end

  def force_current_user_id
    @invitation[:user_id] = current_user.id
  end
end
