class SessionsController < ApplicationController
  def create
    # raise request.env['omniauth.auth'].to_yaml
    auth = request.env['omniauth.auth']
    user = User.find_by_fid(auth['uid']) || User.create(:fid => auth['uid'], :name => auth['info']['name'])

    session[:user_id] = user.id
    # session[:fid]     = user.id
    # todo remove
    session[:image]   = auth['info']['image']

    redirect_to root_url, :notice => "User '#{user.name}' signed in through Facebook!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "User signed out."
  end
end
