require "spec_helper"

describe BlacklistEntriesController do
  describe "routing" do

    context 'by provider' do

      it "routes to #create" do
        post("/api/providers/facebook/users/1/block").should route_to("blacklist_entries#create", :provider => 'facebook', :blocked_uid => '1')
      end

      it "routes to #destroy" do
        delete("/api/providers/facebook/users/1/block").should route_to("blacklist_entries#destroy", :provider => 'facebook', :blocked_uid => '1')
      end

    end
  
    context 'by User.id' do

      it "routes to #create" do
        post("/api/users/block/1/").should route_to("blacklist_entries#create", :blocked_user_id => '1')
      end

      it "routes to #destroy" do
        delete("/api/users/block/1/").should route_to("blacklist_entries#destroy", :blocked_user_id => '1')
      end

    end
  
  end
end
