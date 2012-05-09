require "spec_helper"

describe WatchingsController do
  describe "nested routing within Slides" do
  
    it "routes to #create" do
      post("/api/rounds/1/round_lock/watchings").should route_to("watchings#create", :round_id => "1")
    end

    # it "routes to #show" do
    #   get("/api/rounds/1/round_lock/watchings").should route_to("watchings#show", :round_id => "1")
    # end

    # it "routes to #destroy" do
    #   delete("/api/rounds/1/round_lock/watchings").should route_to("watchings#destroy", :round_id => "1")
    # end

  end
end
