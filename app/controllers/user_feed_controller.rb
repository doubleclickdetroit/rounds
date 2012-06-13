class UserFeedController < ApplicationController

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
  end

end
