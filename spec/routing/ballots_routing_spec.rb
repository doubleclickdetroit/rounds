require "spec_helper"

describe BallotsController do
  describe 'feed routing' do

    it "routes to #index" do
      get("/api/users/me/ballots").should route_to("ballots#index")
    end

    it "routes to #index with :user_id" do
      get("/api/providers/facebook/users/525/ballots").should route_to("ballots#index", :provider => 'facebook', :uid => '525')
    end

    it "routes to #index with :user_id" do
      get("/api/users/525/ballots").should route_to("ballots#index", user_id: '525')
    end

  end

  describe "nested routing within Slides" do

    it "routes to #index" do
      get("/api/slides/1/ballots").should route_to("ballots#index", :slide_id => "1")
    end
  
    it "routes to #create" do
      post("/api/slides/1/vote/2").should route_to("ballots#create", :slide_id => "1", :vote => "2")
    end

  end
end
