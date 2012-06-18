require "spec_helper"

describe '/api/users/' do

  describe "routing" do
  
    context 'for user feeds' do

      it "routes to #index" do
        get("/api/users/me").should route_to("user_feed#show")
      end

      # todo i hate the controller for this
      it "routes to #index" do
        post("/api/users/me/friends").should route_to("user_feed#friends")
      end

      it "routes to #index for provider/uid" do
        get("/api/providers/facebook/users/525/").should route_to("user_feed#show", :provider => 'facebook', :uid => '525')
      end

      it "routes to #index with :user_id" do
        get("/api/users/525/").should route_to("user_feed#show", user_id: '525')
      end

    end

  end

end
