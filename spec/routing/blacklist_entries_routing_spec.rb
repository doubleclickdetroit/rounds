require "spec_helper"

describe BlacklistEntriesController do
  describe "routing" do
  
    it "routes to #create" do
      post("/api/users/block/1/").should route_to("blacklist_entries#create", :fid => '1')
    end

    it "routes to #destroy" do
      delete("/api/users/unblock/1/").should route_to("blacklist_entries#destroy", :fid => '1')
    end

  end
end
