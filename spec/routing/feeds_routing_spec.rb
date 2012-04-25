require "spec_helper"

describe FeedsController do
  describe "routing" do
  
    it "routes to #activity" do
      get("/api/users/1/activity").should route_to("feeds#activity", :fid => "1")
    end

    it "routes to #friends_activity" do
      get("/api/users/1/friends_activity").should route_to("feeds#friends_activity", :fid => "1")
    end

    it "routes to #recent" do
      get("/api/users/recent").should route_to("feeds#recent")
    end

    it "routes to #whats_hot" do
      get("/api/users/whats_hot").should route_to("feeds#whats_hot")
    end

  end
end
