require "spec_helper"

describe InvitationsController do

  describe "nested routing within Rounds" do
  
    it "routes to #index" do
      get("/api/rounds/1/invitations").should route_to("invitations#index", :round_id => "1")
    end

    it "routes to #create" do
      post("/api/rounds/1/invitations/2").should route_to("invitations#create", :round_id => "1", :invited_user_id => "2")
    end

    it "routes to #destroy" do
      delete("/api/rounds/1/invitations/2").should route_to("invitations#destroy", :id => "2", :round_id => "1")
    end

  end

end
