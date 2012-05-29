require "spec_helper"

describe '/api/users/' do

  describe "routing" do
  
    context 'for user feeds' do

      it "routes to #index" do
        get("/api/me").should route_to("user_feed#show")
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
