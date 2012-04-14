require "spec_helper"

describe SlidesController do
  describe "routing" do
  
    it "routes to #index" do
      get("/api/slides").should route_to("slides#index")
    end

    it "routes to #show" do
      get("/api/slides/2").should route_to("slides#show", :id => "2")
    end

    it "routes to #create" do

      post("/api/slides").should route_to("slides#create")
    end

    it "routes to #update" do
      put("/api/slides/2").should route_to("slides#update", :id => "2")
    end

    it "routes to #destroy" do
      delete("/api/slides/2").should route_to("slides#destroy", :id => "2")
    end

  end


  describe "nested routing within Rounds" do
  
    it "routes to #index" do
      get("/api/rounds/1/slides").should route_to("slides#index", :round_id => "1")
    end

    it "routes to #show" do
      get("/api/rounds/1/slides/2").should route_to("slides#show", :id => "2", :round_id => "1")
    end

    it "routes to #create" do
      post("/api/rounds/1/slides").should route_to("slides#create", :round_id => "1")
    end

    it "routes to #update" do
      put("/api/rounds/1/slides/2").should route_to("slides#update", :id => "2", :round_id => "1")
    end

    it "routes to #destroy" do
      delete("/api/rounds/1/slides/2").should route_to("slides#destroy", :id => "2", :round_id => "1")
    end

  end
end
