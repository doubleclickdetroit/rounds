require "spec_helper"

describe SessionsController do
  describe "routing" do
    pending 'scope to api'
  
    # todo scope to api
    it "routes to #create" do
      post("/auth/facebook/callback/").should route_to("sessions#create")
    end

    # todo scope to api
    # todo delete
    it "routes to #destroy" do
      get("/signout/").should route_to("sessions#destroy")
    end

  end
end
