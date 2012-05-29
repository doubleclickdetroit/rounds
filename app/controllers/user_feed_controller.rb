class UserFeedController < ApplicationController

  respond_to :json

  def show
    @user = set_user params, allow_user_id: true
    
    @rounds   = @user.own(Round)
    @slides   = @user.own(Slide)
    @comments = @user.own(Comment)
    @ballots  = @user.own(Ballot)

    respond_with foo: 'bar'
  end
end
