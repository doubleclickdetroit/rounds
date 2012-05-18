def random_user
  @users[rand(@users.size)]
end

def random_text
  @lines ||= "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam id vulputate leo. Suspendisse vulputate libero eu leo ornare adipiscing. Cras mattis tristique mollis. Aenean et metus neque, nec porta lacus. Sed quis semper nisl. Nunc vel mi sem, vitae imperdiet metus. Suspendisse purus metus, pulvinar ac scelerisque et, rutrum ultrices urna. Sed faucibus placerat turpis, sed luctus odio aliquam nec. Integer justo diam, rhoncus in malesuada ac, eleifend eget libero. Praesent congue suscipit urna eu semper. Vestibulum velit nisl, porta sit amet aliquam faucibus, semper vel eros. Proin arcu massa, iaculis et malesuada dignissim, egestas eu diam. Vestibulum eleifend ante id nisl sollicitudin ac faucibus diam hendrerit. Vivamus vitae ipsum dui, et tincidunt felis. Nullam posuere odio egestas sapien ornare convallis. Nullam eget mi vel lorem mollis gravida. Mauris quam velit, malesuada nec tempor ac, dapibus quis augue. Suspendisse potenti.".split(/\./).map(&:strip)

  text = ''
  (rand(4)+1).times { text << (@lines[rand(@lines.size)]+". ") }
  text
end

def make_sentence
  # puts "Creating Sentence for Round #{@round.id}"
  fid = random_user().fid
  params = { :round_id => @round.to_param, :fid => fid }
  FactoryGirl.create(:sentence, params) 
end

def make_picture
  # puts "Creating Picture for Round #{@round.id}"
  fid = random_user().fid
  pic = FactoryGirl.build(:picture, :with_file) 
  pic.round_id = @round.to_param
  pic.fid = fid
  pic.save
end

def add_arbitrary_comments_to(slide)
  (rand(5)+1).times do
    slide.comments << FactoryGirl.create(:comment, {:fid => random_user().fid, :text => random_text()})
  end
end

def add_arbitrary_ballots_to(slide)
  rand(4).times do
    slide.ballots << FactoryGirl.create(:ballot, {:fid => FactoryGirl.create(:user).fid, :vote => (rand(5)+1)})
  end
end


puts "** Begin seeding"



##########################################
################ Users ###################
##########################################

puts '  ** Users'

@users = []

@ammar = FactoryGirl.create(:user, :name => 'Ammar Ulmakzumi', :fid => '1')
@ben   = FactoryGirl.create(:user, :name => 'Ben Babics',      :fid => '2')
@brad  = FactoryGirl.create(:user, :name => 'Brad Chase',      :fid => '3')

@users << @ammar
@users << @ben
@users << @brad



##########################################
################ Rounds ##################
##########################################

puts '  ** Round'

@rounds = []

20.times do 
  round = FactoryGirl.create(:round, :fid => random_user().fid)
  @rounds << round
end



##########################################
################ Slides ##################
##########################################

puts '    ** Slides'

@rounds.each do |round|
  @round = round
  (rand(10)+1).times do |i|
    # puts "Round #{round.id} Slide #{i} odd? #{i.odd?}"
    i.odd? ? make_sentence : make_picture 
  end
  @round.save
end



##########################################
############### Comments #################
##########################################

puts '      ** Comments'

@rounds.each do |round|
  round.slides.each do |slide|
    add_arbitrary_comments_to(slide)
  end
  round.save
end



##########################################
############### Ballots ##################
##########################################

puts '      ** Ballots'

@rounds.each do |round|
  round.slides.each do |slide|
    add_arbitrary_ballots_to(slide)
  end
  round.save
end



puts "** Done seeding"
