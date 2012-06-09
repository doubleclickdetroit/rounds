require "spec_helper"

describe RoundsController do

  describe "routing" do
  
    context 'user feeds' do

      it "routes to #index" do
        get("/api/users/me/rounds").should route_to("rounds#index")
      end

      it "routes to #index for provider/uid" do
        get("/api/providers/facebook/users/525/rounds").should route_to("rounds#index", :provider => 'facebook', :uid => '525')
      end

      it "routes to #index with :user_id" do
        get("/api/users/525/rounds").should route_to("rounds#index", user_id: '525')
      end

    end

    context 'CRUD routing' do

      it "routes to #show" do
        get("/api/rounds/2").should route_to("rounds#show", :id => "2")
      end

      it "routes to #create" do
        post("/api/rounds/7").should route_to("rounds#create", slide_limit: '7')
        post("/api/rounds/7/private").should route_to("rounds#create", slide_limit: '7', :private => true)
      end

      it "routes to #destroy" do
        delete("/api/rounds/2").should route_to("rounds#destroy", :id => "2")
      end

    end

  end

end
