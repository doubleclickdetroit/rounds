class BlacklistEntriesController < ApplicationController

  before_filter :check_for_user_ids, :only => [:create,:destroy]

  respond_to :json

  def create
    puts "####################{@blocked_user_id}"
    block = BlacklistEntry.find_or_create_by_user_id_and_blocked_user_id current_user.id, @blocked_user_id

    respond_with block.to_json
  end

  def destroy
    block = BlacklistEntry.find_by_user_id_and_blocked_user_id current_user.id, @blocked_user_id

    respond_with block ? block.destroy : :not_found
  end

private
  def check_for_user_ids
    # todo cleanup
    unless @blocked_user_id = params[:blocked_user_id]
      blocked_uid = params[:blocked_uid]
      provider    = params[:provider]
      auth      ||= Authorization.find_by_provider_and_uid(provider, blocked_uid)
      user = auth.try(:user)
      if user.nil?
        respond_with :not_found
      else
        @blocked_user_id = user.id
      end
    end


    unless @blocked_user_id || (@blocked_uid && @provider) 
      respond_with :bad_request
    end
  end
end
