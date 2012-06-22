require "spec_helper"

describe SessionsController do
  describe "routing" do
    pending 'scope to api'

    it 'should work with :provider'
  
    # todo scope to api
    it "routes to #create" do
      get("/auth/facebook/callback/").should route_to("sessions#create")
    end

    # todo scope to api
    # todo delete
    pending 'delete'
    it "routes to #destroy" do
      get("/signout/").should route_to("sessions#destroy")
    end

  end
end
