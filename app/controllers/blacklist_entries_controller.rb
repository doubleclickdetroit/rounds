class BlacklistEntriesController < ApplicationController
  before_filter :check_for_user_ids, :only => [:create,:destroy]

  respond_to :json

  def create
    ble = BlacklistEntry.find_or_create_by_user_id_and_blocked_user_id @user_id, @blocked_user_id
    respond_with ble.to_json
  end

  def destroy
    ble = BlacklistEntry.find_by_user_id_and_blocked_user_id @user_id, @blocked_user_id
    respond_with ble.destroy.to_json
  end


private
  def check_for_user_ids
    @user_id         = params[:user_id]
    @blocked_user_id = params[:blocked_user_id]

    if @user_id && @blocked_user_id 
      params[:blacklist_entry]             ||= {}
      params[:blacklist_entry][:user_id]         = @user_id 
      params[:blacklist_entry][:blocked_user_id] = @blocked_user_id 
    else
      respond_with :bad_request
    end
  end
end
