require "spec_helper"

describe WatchingsController do

  context 'for regular Watchings' do

    describe 'feed routing' do

      it "routes to #index" do
        get("/api/users/me/watchings").should route_to("watchings#index")
      end

    end

    describe "nested routing within Slides" do

      it "routes to #create" do
        post("/api/rounds/1/watch/").should route_to("watchings#create", :round_id => "1")
      end

      it "routes to #destroy" do
        delete("/api/rounds/1/watch").should route_to("watchings#destroy", :round_id => "1")
      end

      # it "routes to #show" do
      #   get("/api/rounds/1/round_lock/watchings").should route_to("watchings#show", :round_id => "1")
      # end

    end

  end

  context 'for Dibs' do

    describe 'feed routing' do

      it "routes to #index" do
        get("/api/users/me/dibs").should route_to("watchings#index", type: 'Dib')
      end

    end

    describe "nested routing within Slides" do

      it "routes to #create" do
        post("/api/rounds/1/dib").should route_to("watchings#create", :round_id => "1", type: 'Dib')
      end

      it "routes to #destroy" do
        delete("/api/rounds/1/dib").should route_to("watchings#destroy", :round_id => "1", type: 'Dib')
      end

      # it "routes to #show" do
      #   get("/api/rounds/1/round_lock/watchings").should route_to("watchings#show", :round_id => "1")
      # end

    end

  end

end
