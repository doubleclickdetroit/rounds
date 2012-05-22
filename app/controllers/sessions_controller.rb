class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    
    @user = User.via_auth(auth_hash)
    
    session[:user_id] = @user.id
    session[:image]   = auth_hash['info']['image']

    redirect_to root_url, :notice => "User '#{@user.name}' signed in through Facebook!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "User signed out."
  end
end
