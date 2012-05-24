class BlacklistEntriesController < ApplicationController

  before_filter :check_for_user_ids

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
    unless @blocked_user_id = params[:blocked_user_id]
      blocked_user = User.find_by_auth_hash(params)

      if blocked_user.nil?
        head :not_found
      else
        @blocked_user_id = blocked_user.id
      end
    end
  end
end
