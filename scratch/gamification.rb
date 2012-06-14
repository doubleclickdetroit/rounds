# # elements:
# #   points
# #   rank
# #   badges
# # 
# # * points awarded on model layer via after_create callbacks
# # * rank is calculated and saved within those callbacks if needed
# # * badges are also calculated and saved within those callbacks if needed

# config/initializers/gamification.rb

POINTS = {
  Slide => {
    created: 5,
    added_to_round: 2
  },
  Comments => {
    create: 1
  }
}

RANKS = {
  0 => 'Noob',
  10 => 'Member'
  100 => 'Veteran',
  1000 => 'Epic'
}

BADGES = {
}

# app/models/user.rb

class User
  def earned pts
    info = {points: pts}

    self.points += pts
    info[:total_points] = self.points

    rank_vals   = RANKS.keys << self.points
    earned_rank = RANKS.fetch rank_vals.index(self.points)-1 # todo this would wrap... do as a set?
    if self.rank != earned_rank
      self.rank = earned_rank unless self.rank == earned_rank
      info[:rank] = earned_rank
    end
    
    self.save ? info : {error: 'didnt save'}
  end
end

# app/models/slide.rb

class Slide
  after_create :distribute_points
private
  def distribute_points
    creator.earned POINTS[Slide][:created]
    round.creator.earned POINTS[Slide][:added_to_round] unless round.creator == creator
  end
end
