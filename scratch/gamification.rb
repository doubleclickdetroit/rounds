# # elements:
# #   points
# #   rank
# #   badges
# # 
# # * points awarded on model layer via after_create callbacks
# # * rank is calculated and saved within those callbacks if needed
# # * badges are also calculated and saved within those callbacks if needed
# # 
# # points should be persisted three ways:
# #   total points earned
# #   total points purchased
# #   total points possessed

# config/initializers/gamification.rb

# allows POINTS[Model][:action]
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
  Slide => {
    'Artist' => lambda {|user| user.pictures.count  > 20},
    'Author' => lambda {|user| user.sentences.count > 20}
  }
}

# app/models/user.rb

class User
  def earned pts
    info = {points: pts}

    # update points
    info.merge! {total_points: (self.points += pts)}

    # update rank
    info.merge! check_and_update_ranks

    self.save ? info : {error: 'didnt save'}
  end

  def check_and_update_ranks
    info        = {}

    # determine earned_rank
    rank_vals   = (RANKS.keys << self.points).sort.reverse
    earned_rank = rank_vals.slice rank_vals.index(self.points), 1

    # update rank if necessary
    if self.rank != earned_rank
      self.rank = earned_rank unless self.rank == earned_rank
      info[:rank] = earned_rank
    end

    info
  end

  def check_and_award_badges_for model
    my_badges = self.badges.map &:name
    BADGES[model].each do |badge_name, badge_test|
      next if my_badges.include? badge_name
      self.badges << Badge.where(name: badge_name) if badge_test.call self
    end
  end

  def created model
    # score the creation
    info = earned POINTS[model][:created]

    # award badges
    check_and_award_badges_for model

    self.save
    info
  end

  def had model
    # go go super monkey patch!
    self.instance_eval do
      define_method :model_for_had do
        model
      end
    end
  end

  def added_to_round
    # model monkeypatched in from .had
    POINTS[model][:added_to_round]
  end
end

# app/models/slide.rb

class Slide
  after_create :distribute_points
private
  def distribute_points
    # could also pass self as arg
    creator.created Slide
    round.creator.had(Slide).added_to_round unless round.creator == creator
  end
end


























# other

class User
  def earned pts
    info = {points: pts}

    self.points += pts
    info[:total_points] = self.points

    rank_vals   = (RANKS.keys << self.points).sort.reverse
    earned_rank = rank_vals.slice rank_vals.index(self.points), 1
    if self.rank != earned_rank
      self.rank = earned_rank unless self.rank == earned_rank
      info[:rank] = earned_rank
    end
    
    self.save ? info : {error: 'didnt save'}
  end
end
class Slide
  after_create :distribute_points
private
  def distribute_points
    # could also pass self to first hash
    creator.earned POINTS[Slide][:created]
    round.creator.earned POINTS[Slide][:added_to_round] unless round.creator == creator
  end
end
# OR
