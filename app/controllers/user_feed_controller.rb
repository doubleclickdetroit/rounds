class UserFeedController < ApplicationController

  respond_to :json

  def feed
    @user = set_user params, allow_user_id: true

    respond_with foo: 'bar'
  end
end
