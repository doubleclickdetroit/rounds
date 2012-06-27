class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    
    # raise auth_hash.to_yaml

    @user = User.via_auth(auth_hash)
    
    session[:user_id] = @user.id
    session[:image]   = auth_hash['info']['image']

    # # todo in template now
    # @watchings_count          = @user.own(Watching).count
    # @unread_invitations_count = @user.own(Invitation).where(read:false).count

    # todo trys?
    if token = auth_hash.try('credentials').try('token')
      uids = FbGraph::User.me(token).friends.map {|f| f.raw_attributes['id']}
      ids  = uids.reduce([]) {|arr,uid| arr << Authorization.find_by_provider_and_uid('facebook',uid).try(:user_id)}
      @user.friend_ids_csv = ids.reject(&:nil?).join(',')
      @user.save

      cookies[:facebook_token] = token

      # todo cleanup
      @notice = "User '#{@user.name}' signed in through #{auth_hash[:provider].capitalize}!"
      @messages = {
        notice: @notice,
        system: 'Message of the day!'
      }
      class << @user
        attr_accessor :messages
      end
      @user.messages = @messages

      respond_to do |format|
        format.html { render 'sessions/create' }
        format.json
      end
    end

    # @notice = "User '#{@user.name}' signed in through #{auth_hash[:provider].capitalize}!"
    # redirect_to root_url, :notice => "User '#{@user.name}' signed in through #{auth_hash[:provider].capitalize}!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "User signed out."
  end
end
