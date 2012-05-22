class BlacklistEntriesController < ApplicationController

  before_filter :check_for_user_ids, :only => [:create,:destroy]

  respond_to :json

  def create
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
      blocked_uid, provider = params[:blocked_uid], params[:provider]
      user = User.find_by_auth_provider_and_uid(provider, blocked_uid)

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
