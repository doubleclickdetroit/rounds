require "spec_helper"

describe WatchingsController do
  # describe "routing" do
  #   it "routes to #create" do
  #     post("/api/watchings").should route_to("watchings#create")
  #   end
  #   it "routes to #destroy" do
  #     delete("/api/watchings/2").should route_to("watchings#destroy", :id => "2")
  #   end
  # end


  describe "nested routing within Slides" do
  
    it "routes to #create" do
      post("/api/slides/1/watchings").should route_to("watchings#create", :slide_id => "1")
    end

    it "routes to #destroy" do
      delete("/api/slides/1/watchings").should route_to("watchings#destroy", :slide_id => "1")
    end

  end
end
