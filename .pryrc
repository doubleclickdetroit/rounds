# begging for trouble :D
class << nil
  def +(num)
    puts "begin toggle_round_lock"
    0 + num
  end
end

#########################
######## Resque #########
#########################

def create_random_round_image
  @round = FactoryGirl.create(:round)

  6.times {|i| i.odd? ? make_sentence : make_picture}

  @round.complete = true
  @round.save
end

def test_round_lock_timeout(seconds=5)
  lock = FactoryGirl.create(:round_lock)
  Resque.enqueue_in(seconds, LockDissolver, lock.id)
end

def make_sentence
  params = { :round_id => @round.to_param }
  FactoryGirl.create(:sentence, params) 
end

def make_picture
  pic = FactoryGirl.create(:picture, :with_file) 
  pic.round_id = @round.to_param
  pic.save
end

#########################
###### PrivatePub #######
#########################

def lock_round round_id=1, user_id=1
  RoundLock.create round_id: round_id, user_id: user_id 
end

def unlock_round round_id=1
  RoundLock.where(round_id: round_id).first.destroy
end

def toggle_round_lock round_id=1
  (@i+=1).odd? ? lock_round(round_id) : unlock_round(round_id) while gets !~ /exit/
end

def watch_round round_id=1, user_id=2 # default to ben
  Watching.create round_id: round_id, user_id: user_id
end

def unwatch_round round_id=1
  Watching.where(round_id: round_id).first.destroy
end

alias :l :lock_round
alias :u :unlock_round
alias :t :toggle_round_lock
