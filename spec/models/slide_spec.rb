require 'spec_helper'

describe Slide do
  before(:each) do
    @round = Factory(:round)

    @slide = Factory(:slide) 
    @round.slides << @slide 

    @slide.comments << Factory(:comment)
    @slide.comments << Factory(:comment)
  end

  it 'should belong to a Round' do
    @slide.round.should be_an_instance_of Round
  end

  it 'should have many Comments' do
    @slide.comments.all? do |comment|
      comment.instance_of?(Comment)
    end.should be_true
  end

  describe '.comment_count' do
    it 'should return the number of comments' do
      @slide.comment_count.should == @slide.comments.count
    end
  end

  it 'should have many Ballots', :focus do
    @slide.ballots << Factory(:ballot)
    @slide.ballots << Factory(:ballot)

    @slide.ballots.all? do |ballot|
      ballot.instance_of?(Ballot)
    end.should be_true
  end

  describe '.create_next' do
    before(:each) do
      @round = Factory(:round)
      fid = 1
      Factory(:user, :fid => fid)
      @lock  = Factory(:round_lock, :round_id => @round.id, :fid => fid)
    end

    it 'should not save if a RoundLock exists by another user for .round' 

    context 'sentence' do
      before(:each) do
        Factory(:picture, :round_id => @round.id)
        @sentence = Factory.build(:sentence, :round_id => @round.id).attributes
        @picture  = Factory.build(:picture, :round_id => @round.id).attributes
      end

      it 'should allow a Sentence added after a Picture' do
        expect {
          Slide.create_next(@sentence)
        }.to change(Sentence, :count).by(1)
      end

      it 'should raise for a Sentence after a Sentence' do
        expect {
          Slide.create_next(@picture)
        }.to raise_error('Cannot create a picture after a picture')
      end
    end

    context 'picture' do
      before(:each) do
        Factory(:sentence, :round_id => @round.id)
        @picture  = Factory.build(:picture, :round_id => @round.id).attributes
        @sentence = Factory.build(:sentence, :round_id => @round.id).attributes
      end

      it 'should allow a Picture added after a Sentence' do
        expect {
          Slide.create_next(@picture)
        }.to change(Picture, :count).by(1)
      end

      it 'should raise for a Picture after a Picture' do
        expect {
          Slide.create_next(@sentence)
        }.to raise_error('Cannot create a sentence after a sentence')
      end
    end

    it 'should raise without a proper slide[:type]' do
      slide = Factory.build(:sentence, :round_id => @round.id, :type => 'Foobar').attributes

      expect {
        Slide.create_next(slide)
      }.to raise_error('"Foobar" is not a valid slide type')
    end

    it 'should raise without a lock' do
      Factory(:sentence, :round_id => @round.id)
      slide = Factory.build(:picture, :round_id => @round.id).attributes
      @lock.destroy 

      expect {
        Slide.create_next(slide)
      }.to raise_error('Cannot create slide without round lock')
    end

    it 'should raise if the RoundLock doesnt belong to the User' do
      fid = 525
      Factory(:user, :fid => fid)
      @lock.fid = fid
      @lock.save

      Factory(:sentence, :round_id => @round.id)
      slide = Factory.build(:picture, :round_id => @round.id).attributes
      expect {
        Slide.create_next(slide)
      }.to raise_error('User does not have the round locked')
    end

    # todo instead, create lock upon round creation
    it "shouldn't require a lock for the first slide..." 

    it 'should destroy the lock upon successful slide creation' do
      Factory(:sentence, :round_id => @round.id)
      slide = Factory.build(:picture, :round_id => @round.id).attributes

      RoundLock.count.should == 1
      expect {
        Slide.create_next(slide)
      }.to change(RoundLock, :count).by(-1)
    end
  end

  describe '.to_hash' do
    before(:each) do
      @slide.stub(:content).and_return('')
      @hash = @slide.to_hash 
    end

    keys = %w[type id round_id fid created_at updated_at comment_count votes content]
    it "should have no other keys than these #{keys.inspect}" do
      (@hash.keys && keys).sort.should == @hash.keys.sort
    end
  end

  describe '.to_json' do
    it 'should call Slide.to_hash' do
      @slide.should_receive :to_hash
      @slide.to_json
    end

    it 'should call .to_json on Slide.to_hash' do
      @slide.stub(:to_hash).and_return({})
      Hash.any_instance.should_receive :to_json
      @slide.to_json
    end
  end

  describe 'after_create' do
    it 'should assign a position of 0 if it is the first Slide in the Round' do
      @round.slides = []
      slide = Factory(:slide, :round_id => @round.to_param)
      @round.slides << slide
      slide.position.should == 0
    end

    it 'should assign a position one greater than the last Slide in the Round' do
      @round.slides = []
      slide = Factory(:slide, :round_id => @round.to_param)
      @round.slides << slide
      slide = Factory(:slide, :round_id => @round.to_param)
      @round.slides << slide
      slide.position.should == 1
    end
  end

  describe '.created_by' do
    pending 'do i need to check this more thoroughly here or just in the controller spec?'

    it 'should return a User' do
      @slide.created_by = Factory(:user)
      @slide.created_by.should be_an_instance_of(User)
    end
  end

  describe '.creator' do
    it 'should simply call .created_by' do
      @slide.should_receive :created_by
      @slide.creator
    end
  end

  describe '.of_type' do
    before(:each) do
      # todo wasteful, 43 created before
      Slide.destroy_all

      Factory(:slide, :type => 'Sentence') 
      Factory(:slide, :type => 'Picture') 
    end

    it 'should only return Sentences when passed that type' do
      Slide.count.should == 2
      Slide.of_type('Sentence').count.should == 1
    end

    it 'should only return Pictures when passed that type' do
      Slide.count.should == 2
      Slide.of_type('Picture').count.should == 1
    end
  end

  describe '.recent' do
    before(:each) do
      9.times { Factory(:slide) }
    end

    pending 'test recent (by date)? not just limit 8?'
    it 'should return the 8 most recent Slides' do
      Slide.recent.count.should == 8
    end
  end

  describe '.before' do
    it 'should only return Slides created before a specific Time' do
      time = Time.now

      # todo wasteful
      Slide.destroy_all

      slide1 = Factory(:slide, :created_at => time-1)
      slide2 = Factory(:slide, :created_at => time+1)

      Slide.count.should == 2
      Slide.before(time).count.should == 1
 
    end
    pending 'actual test of time'
  end

  describe '.friends' do
    pending 'converting this over'
    before(:each) do
      8.times { Factory(:slide) }
      friend1 = Factory(:user)
      friend2 = Factory(:user)
      Factory(:slide, :fid => friend1.fid)
      Factory(:slide, :fid => friend2.fid)
      @fids = [friend1.fid, friend2.fid]
    end

    it 'should only return Slides made by friends' do
      Slide.friends(@fids).count.should == 2
    end
  end

  describe '.friends_recent' do
    pending 'converting this over'
    before(:each) do
      friend = Factory(:user)
      9.times { Factory(:slide, :fid => friend.fid) }
      @fids = [friend.fid]
    end

    it 'should only return 8 Slides at most' do
      Slide.friends_recent(@fids).count.should == 8
    end
  end

  describe ".of_type_and_before" do
    pending 'just chains two scopes...'
    before(:each) do
      @time = Time.now
      5.times { Factory(:sentence, :created_at => @time) }
      5.times { Factory(:picture, :created_at => @time) }
      @time += 30 # arbitrary
      4.times { Factory(:sentence, :created_at => @time) }
      4.times { Factory(:picture, :created_at => @time) }
    end

    [Sentence,Picture].each do |klass|
      it "should return the 8 most recent slides of the proper type (#{klass.to_s}) with no time arg" do
        slides = Slide.of_type_and_before(klass.to_s)
        slides.count.should == 8 # todo spec most recent instead
        slides.all?{|s|s.instance_of?(klass)}.should be_true
      end

      it "should return the slides before the proper time and of the proper type (#{klass.to_s})" do
        slides = Slide.of_type_and_before(klass.to_s, @time)
        slides.count.should == 5 
        slides.all?{|s|s.instance_of?(klass)}.should be_true
      end
    end
  end

  describe '.feed' do
    [Sentence, Picture].each do |klass|
      describe "for #{klass}" do
        before(:each) do
          Slide.destroy_all

          fid   = 525 
          @fids = [fid]

          4.times { Factory(klass.to_s.downcase.intern) }
          4.times { Factory(klass.to_s.downcase.intern, :fid => fid) }
        end

        pending 'unhappy path? nils?'

        it 'should put .invitations hashed as the value for the key invitations'
        it 'should put .private_feed as the value for the key private'
        it 'should put .friends_recent hashed as the value for the key friends' do
          friends_hash = klass.friends_recent(@fids).map(&:to_hash)
          klass.feed(@fids)['friends'].should == friends_hash
        end
        it 'should put .recent hashed as the value for the key community' do
          recent_hash = klass.recent.map(&:to_hash)
          klass.feed(@fids)['community'].should == recent_hash
        end

        it "should have an Array of Hashes as the value for all keys"

        it 'should return a Hash' do
          Slide.feed(@fids).should be_a_kind_of Hash
        end
      end
    end
  end

end
