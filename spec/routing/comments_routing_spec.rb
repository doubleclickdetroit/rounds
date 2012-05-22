require "spec_helper"

describe CommentsController do
  
  describe 'feed routing' do

    it "routes to #index" do
      get("/api/comments").should route_to("comments#index")
    end

    it "routes to #index with :user_id" do
      get("/api/providers/facebook/users/525/comments").should route_to("comments#index", :provider => 'facebook', :uid => '525')
    end

  end

  describe "routing" do
  
    it "routes to #create" do
      post("/api/comments").should route_to("comments#create")
    end

    it "routes to #update" do
      put("/api/comments/2").should route_to("comments#update", :id => "2")
    end

    it "routes to #destroy" do
      delete("/api/comments/2").should route_to("comments#destroy", :id => "2")
    end

  end


  describe "nested routing within Slides" do
  
    it "routes to #index" do
      get("/api/slides/1/comments").should route_to("comments#index", :slide_id => "1")
    end

    it "routes to #create" do
      post("/api/slides/1/comments").should route_to("comments#create", :slide_id => "1")
    end

    it "routes to #update" do
      put("/api/slides/1/comments/2").should route_to("comments#update", :id => "2", :slide_id => "1")
    end

    it "routes to #destroy" do
      delete("/api/slides/1/comments/2").should route_to("comments#destroy", :id => "2", :slide_id => "1")
    end

  end

end
