class UserFeedController < ApplicationController
  before_filter :check_for_provider_and_uids, only: [:friends]

  respond_to :json

  def show
    @user = set_user params, allow_user_id: true
    is_current_user = @user == current_user
    
    @invitations = is_current_user ? @user.own(Invitation) : []
    @slides      = @user.own(Slide)
    @comments    = @user.own(Comment)
    @ballots     = @user.own(Ballot)

    @skip_user = true
    respond_with 'user_feed/show'
  end

  def friends
    @user_ids = current_user.set_friends(params[:provider], params[:uids])
    render json: @user_ids
  end

private
  def check_for_provider_and_uids
    @provider, @uids = params[:provider], params[:uids]
    head :not_acceptable unless @provider && @uids  
  end
end
