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
  user_id = random_user().id
  params = { :round_id => @round.to_param, :user_id => user_id }
  FactoryGirl.create(:sentence, params) 
end

def make_picture
  user_id = random_user().id
  pic = FactoryGirl.create(:picture, :with_file) 
  pic.round_id = @round.to_param
  pic.user_id = user_id
  pic.save
end

def add_arbitrary_comments_to(slide)
  (rand(3)+1).times do
    FactoryGirl.create(:comment, {:user_id => random_user().id, :slide_id => slide.id, :text => random_text()})
    print '.'
  end
end

def add_arbitrary_ballots_to(slide)
  @users.sample(rand(@users.count+1)).each do |user|
    user_id = user.id
    vote    = rand(5)+1
    FactoryGirl.create(:ballot, {:user_id => user_id, :slide_id => slide.id, :vote => vote})
    print '.'
  end
end







puts "** Begin seeding"



##########################################
################ Users ###################
##########################################

print '  ** Users '

@users = []


@ammar = FactoryGirl.create(:user, :name => 'Ammar Almakzumi')
FactoryGirl.create(:authorization, :user_id => @ammar.id, :provider => 'facebook', :uid => '535058569')
@users << @ammar
print '.'

@ben   = FactoryGirl.create(:user, :name => 'Ben Babics')
FactoryGirl.create(:authorization, :user_id => @ben.id, :provider => 'facebook', :uid => '500032277')
@users << @ben
print '.'

@brad  = FactoryGirl.create(:user, :name => 'Brad Chase')
FactoryGirl.create(:authorization, :user_id => @brad.id, :provider => 'facebook', :uid => '30118972')
@users << @brad
print '.'

class User
  def add_facebook_image_path
    fid = self.authorizations.where(provider: 'facebook').first.uid
    self.image_path = "http://graph.facebook.com/#{fid}/picture?type=square"
    self.save
  end
end

@users.each &:add_facebook_image_path



##########################################
################ Rounds ##################
##########################################

print "\n  ** Round "

@rounds = []

10.times do 
  round = FactoryGirl.create(:round, :user_id => random_user().id)
  print '.'
  @rounds << round
end



##########################################
################ Slides ##################
##########################################

print "\n    ** Slides "

@rounds.each do |round|
  @round = round
  (rand(7)+1).times do |i|
    i.odd? ? make_sentence : make_picture 
    print '.'
  end
  @round.save
end



##########################################
############### Comments #################
##########################################

print "\n      ** Comments "

@rounds.each do |round|
  round.slides.each do |slide|
    add_arbitrary_comments_to(slide)
  end
  round.save
end



##########################################
############### Ballots ##################
##########################################

print "\n      ** Ballots "

@rounds.each do |round|
  round.slides.each do |slide|
    add_arbitrary_ballots_to(slide)
  end
  round.save
end



puts "\n** Done seeding"
