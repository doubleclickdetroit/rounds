require "spec_helper"

describe BallotsController do
  describe "nested routing within Slides" do
  
    it "routes to #create" do
      post("/api/slides/1/vote/2").should route_to("ballots#create", :slide_id => "1", :vote => "2")
    end

  end
end
