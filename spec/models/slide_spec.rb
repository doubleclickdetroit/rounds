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

  describe '.to_hash' do
    before(:each) do
      @slide.stub(:content).and_return('')
      @hash = @slide.to_hash 
    end

    keys = %w[type id round_id fid created_at updated_at content]
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

  describe '.before_create' do
    it 'should not save if a RoundLock exists for .round' do
      round = Factory(:round)
      Factory(:round_lock, :round_id => round.id)

      slide = Factory.build(:slide, :round_id => round.id)

      expect {
        slide.save
      }.to change(Slide, :count).by(0)
    end
  end

end
