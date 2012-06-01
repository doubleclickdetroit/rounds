require "spec_helper"

describe RoundLocksController do
  describe "nested routing within Rounds" do
  
    it "routes to #show" do
      get("/api/rounds/1/lock").should route_to("round_locks#show", :round_id => "1")
    end

    it "routes to #create" do
      post("/api/rounds/1/lock").should route_to("round_locks#create", :round_id => "1")
    end

    it "routes to #destroy" do
      delete("/api/rounds/1/lock").should route_to("round_locks#destroy", :round_id => "1")
    end

  end
end
