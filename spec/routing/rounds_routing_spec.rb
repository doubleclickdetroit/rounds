require "spec_helper"

describe RoundsController do

  describe "routing" do
  
    context 'user feeds' do

      it "routes to #index" do
        get("/api/rounds").should route_to("rounds#index")
      end

      it "routes to #index with :user_id" do
        get("/api/providers/facebook/users/525/rounds").should route_to("rounds#index", :provider => 'facebook', :uid => '525')
      end

    end

    context 'CRUD routing' do

      it "routes to #show" do
        get("/api/rounds/2").should route_to("rounds#show", :id => "2")
      end

      it "routes to #create" do

        post("/api/rounds").should route_to("rounds#create")
      end

      it "routes to #update" do
        put("/api/rounds/2").should route_to("rounds#update", :id => "2")
      end

      it "routes to #destroy" do
        delete("/api/rounds/2").should route_to("rounds#destroy", :id => "2")
      end

    end

  end


  # describe "nested routing within Rounds" do
  # 
  #   it "routes to #index" do
  #     get("/api/rounds/1/slides").should route_to("slides#index", :round_id => "1")
  #   end

  #   it "routes to #show" do
  #     get("/api/rounds/1/slides/2").should route_to("slides#show", :id => "2", :round_id => "1")
  #   end

  #   it "routes to #create" do
  #     post("/api/rounds/1/slides").should route_to("slides#create", :round_id => "1")
  #   end

  #   it "routes to #update" do
  #     put("/api/rounds/1/slides/2").should route_to("slides#update", :id => "2", :round_id => "1")
  #   end

  #   it "routes to #destroy" do
  #     delete("/api/rounds/1/slides/2").should route_to("slides#destroy", :id => "2", :round_id => "1")
  #   end

  # end
end
