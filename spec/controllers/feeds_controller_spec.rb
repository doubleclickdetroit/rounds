require 'spec_helper'

describe FeedsController do

  it 'should authenticate the user'

  describe "GET 'activity'" do
    it "returns http success" do
      get 'activity'
      response.should be_success
    end
  end

  describe "GET 'friends_activity'" do
    it "returns http success" do
      get 'friends_activity'
      response.should be_success
    end
  end

  describe "GET 'recent'" do
    it "returns http success" do
      get 'recent'
      response.should be_success
    end
  end

  describe "GET 'whats_hot'" do
    it "returns http success" do
      get 'whats_hot'
      response.should be_success
    end
  end

end
