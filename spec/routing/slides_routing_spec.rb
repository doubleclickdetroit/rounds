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

  describe "subclassed routing" do

    context "Sentence" do

      it "routes to #create" do
        post("/api/rounds/1/sentences").should route_to("slides#create", :type => 'Sentence', :round_id => '1')
      end

      it "routes to #feed" do
        get("/api/sentences").should route_to("slides#feed", :type => 'Sentence')
      end

      it "routes to #recent" do
        get("/api/sentences/recent").should route_to("slides#recent", :type => 'Sentence')
      end

      it "routes to #friends" do
        get("/api/sentences/friends").should route_to("slides#friends", :type => 'Sentence')
      end

    end

    context "Picture" do

      it "routes to #create" do
        post("/api/rounds/1/pictures").should route_to("slides#create", :type => 'Picture', :round_id => '1')
      end

      it "routes to #feed" do
        get("/api/pictures").should route_to("slides#feed", :type => 'Picture')
      end

      it "routes to #recent" do
        get("/api/pictures/recent").should route_to("slides#recent", :type => 'Picture')
      end

      it "routes to #friends" do
        get("/api/pictures/friends").should route_to("slides#friends", :type => 'Picture')
      end

    end

  end
end
