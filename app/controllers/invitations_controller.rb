class InvitationsController < ApplicationController

  before_filter :setup_invitation, :only => [:index,:create]
  before_filter :check_for_round, :only => :create
  before_filter :check_for_invitees, :only => :create
  
  respond_to :json


  def index
    if round_id = params[:round_id]
      @invitations = Round.find(round_id).invitations
    else
      @user = current_user

      @invitations = @user.own(Invitation).before_or_after(params)
    end

    respond_with @invitations
  end

  def create
    current_user.invite params[:invitees], to: @round
    respond_with :created
  end

  def destroy
    respond_with Invitation.destroy(params[:id]).to_json
  end


private
  def setup_invitation
    @invitation = {}
  end

  def check_for_round
    # todo ?
    if round_id = params[:round_id] 
      @round = Round.find(params[:round_id])
    else
      head :not_acceptable
    end
  end

  def check_for_invitees
    # todo ?
    if not @invitees = params[:invitees]
      head :not_acceptable
    end
  end
end
