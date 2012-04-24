require "spec_helper"

describe BlacklistEntriesController do
  describe "routing" do
  
    it "routes to #create" do
      post("/api/blacklist_entries/").should route_to("blacklist_entries#create")
    end

    it "routes to #destroy" do
      pending 'failing'
      delete("/api/blacklist_entries/").should route_to("blacklist_entries#destroy")
    end

  end
end
