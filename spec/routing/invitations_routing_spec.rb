require "spec_helper"

describe InvitationsController do

  describe "nested routing within Rounds" do
  
    context 'user feeds' do

      it "routes to #index" do
        get("/api/invitations").should route_to("invitations#index")
      end

      it "routes to #index with :user_id" do
        pending 'i dont think this is needed'
        get("/api/providers/facebook/users/525/invitations").should route_to("invitations#index", :provider => 'facebook', :uid => '525')
      end

    end

    it "routes to #create" do
      post("/api/rounds/1/invitations/2").should route_to("invitations#create", :round_id => "1", :invited_user_id => "2")
    end

    it "routes to #destroy" do
      delete("/api/rounds/1/invitations/2").should route_to("invitations#destroy", :id => "2", :round_id => "1")
    end

  end

end
