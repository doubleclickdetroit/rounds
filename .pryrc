# begging for trouble :D
class << nil
  def +(num)
    puts "begin toggle_round_lock"
    0 + num
  end
end

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
