require 'spec_helper'

describe Watching do
  before(:each) do
    @watching = Factory(:watching)
  end

  describe 'before_destroy callbacks' do
    it 'should call send_push_notification' do
      @watching.should_receive :send_push_notification
      @watching.destroy
    end

    it 'should send a push notification to the user'
  end
end
