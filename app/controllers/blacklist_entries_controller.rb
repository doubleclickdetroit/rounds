class BlacklistEntriesController < ApplicationController
  before_filter :check_for_fids, :only => [:create,:destroy]

  respond_to :json

  def create
    ble = BlacklistEntry.find_or_create_by_fid_and_blocked_fid @fid, @blocked_fid
    respond_with ble.to_json
  end

  def destroy
    ble = BlacklistEntry.find_by_fid_and_blocked_fid @fid, @blocked_fid
    respond_with ble.destroy.to_json
  end


private
  def check_for_fids
    @fid         = params[:fid]
    @blocked_fid = params[:blocked_fid]

    if @fid && @blocked_fid 
      params[:blacklist_entry]             ||= {}
      params[:blacklist_entry][:fid]         = @fid 
      params[:blacklist_entry][:blocked_fid] = @blocked_fid 
    else
      respond_with :bad_request
    end
  end
end
