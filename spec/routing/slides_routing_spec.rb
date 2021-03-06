require "spec_helper"

describe SlidesController do

  describe 'user feeds' do

    it "routes to #index" do
      get("/api/users/me/slides").should route_to("slides#index")
    end

    it "routes to #index with provider/uid" do
      get("/api/providers/facebook/users/525/slides").should route_to("slides#index", :provider => 'facebook', :uid => '525')
    end

    it "routes to #index with :user_id" do
      get("/api/users/525/slides").should route_to("slides#index", user_id: '525')
    end

  end

  describe "routing" do
  
    it "routes to #show" do
      get("/api/slides/2").should route_to("slides#show", :id => "2")
    end

    it "routes to #create" do
      post("/api/slides").should route_to("slides#create")
    end

    # it "routes to #update" do
    #   put("/api/slides/2").should route_to("slides#update", :id => "2")
    # end

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

    # it "routes to #update" do
    #   put("/api/rounds/1/slides/2").should route_to("slides#update", :id => "2", :round_id => "1")
    # end

    it "routes to #destroy" do
      delete("/api/rounds/1/slides/2").should route_to("slides#destroy", :id => "2", :round_id => "1")
    end

  end

  describe "subclassed routing" do

    context "Sentence" do

      it "routes to #create" do
        post("/api/rounds/1/sentences").should route_to("slides#create", :type => 'Sentence', :round_id => '1')
      end

      it "routes to #feed" do
        get("/api/sentences").should route_to("slides#feed", :type => 'Sentence')
      end

      it "routes to #community" do
        get("/api/sentences/community").should route_to("slides#community", :type => 'Sentence')
      end

      it "routes to #friends" do
        get("/api/sentences/friends").should route_to("slides#friends", :type => 'Sentence')
      end

      it "routes to #private" do
        get("/api/sentences/private").should route_to("slides#private", :type => 'Sentence')
      end

    end

    context "Picture" do

      it "routes to #create" do
        post("/api/rounds/1/pictures").should route_to("slides#create", :type => 'Picture', :round_id => '1')
      end

      it "routes to #update" do
        put("/api/pictures/1/uploaded").should route_to("slides#update", :type => 'Picture', :id => '1', uploaded: true)
      end

      it "routes to #feed" do
        get("/api/pictures").should route_to("slides#feed", :type => 'Picture')
      end

      it "routes to #community" do
        get("/api/pictures/community").should route_to("slides#community", :type => 'Picture')
      end

      it "routes to #friends" do
        get("/api/pictures/friends").should route_to("slides#friends", :type => 'Picture')
      end

      it "routes to #private" do
        get("/api/pictures/private").should route_to("slides#private", :type => 'Picture')
      end

    end

  end
end
