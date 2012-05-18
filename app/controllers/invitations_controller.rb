class InvitationsController < ApplicationController
  before_filter :setup_invitation, :only => [:index,:create]
  before_filter :check_for_round_id, :only => [:index,:create]
  before_filter :check_for_invited_fid, :only => :create
  before_filter :force_current_fid, :only => :create
  
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

  def check_for_invited_fid
    # todo ?
    if not @invited_fid = params[:invited_fid]
      respond_with :bad_request
    else
      @invitation[:invited_fid] ||= @invited_fid
    end
  end

  def force_current_fid
    @invitation[:fid] = current_user.fid
  end
end
