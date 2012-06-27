def random_user
  @users[rand(@users.size)]
end

def random_text
  @lines ||= "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam id vulputate leo. Suspendisse vulputate libero eu leo ornare adipiscing. Cras mattis tristique mollis. Aenean et metus neque, nec porta lacus. Sed quis semper nisl. Nunc vel mi sem, vitae imperdiet metus. Suspendisse purus metus, pulvinar ac scelerisque et, rutrum ultrices urna. Sed faucibus placerat turpis, sed luctus odio aliquam nec. Integer justo diam, rhoncus in malesuada ac, eleifend eget libero. Praesent congue suscipit urna eu semper. Vestibulum velit nisl, porta sit amet aliquam faucibus, semper vel eros. Proin arcu massa, iaculis et malesuada dignissim, egestas eu diam. Vestibulum eleifend ante id nisl sollicitudin ac faucibus diam hendrerit. Vivamus vitae ipsum dui, et tincidunt felis. Nullam posuere odio egestas sapien ornare convallis. Nullam eget mi vel lorem mollis gravida. Mauris quam velit, malesuada nec tempor ac, dapibus quis augue. Suspendisse potenti.".split(/\./).map(&:strip)

  text = ''
  (rand(4)+1).times { text << (@lines[rand(@lines.size)]+". ") }
  text
end

# def random_text(sentence_text=true)
#   @comment_lines  ||= "Ice cream brownie lollipop marshmallow gingerbread lemon drops chupa chups. Chocolate cake tiramisu sweet sweet roll croissant souffle gingerbread. Gummies croissant oat cake muffin tootsie roll tiramisu powder sesame snaps. Cheesecake lollipop biscuit cookie. Bonbon carrot cake apple pie cake lollipop carrot cake souffle jelly-o toffee. Pudding donut lemon drops. Ice cream tart jelly powder candy canes dragee pie apple pie pie. Souffle marshmallow chocolate fruitcake cotton candy powder dessert cookie. Tiramisu chocolate bar cookie sesame snaps tootsie roll. Jelly beans faworki biscuit jelly-o danish. Donut oat cake candy canes oat cake. Gummi bears cupcake pastry cake jujubes gingerbread applicake apple pie. Tart croissant brownie cotton candy cupcake sugar plum wypas. Chocolate bar cookie cupcake dessert muffin oat cake faworki jelly-o faworki. Applicake lemon drops muffin croissant candy macaroon candy croissant. Caramels icing tiramisu pie tootsie roll liquorice. Apple pie croissant oat cake danish chocolate chocolate cake. Lemon drops dessert sweet lollipop donut. Applicake pudding toffee toffee. Pie wypas chocolate bar chupa chups oat cake gummi bears. Sesame snaps bear claw chupa chups jelly-o cotton candy biscuit. Faworki souffle carrot cake pie. Gummi bears souffle toffee liquorice jelly-o. Topping chocolate chocolate cake bonbon dragee sesame snaps wafer sugar plum. Chocolate cake toffee cupcake lemon drops. Marshmallow icing dessert jelly. Sweet roll icing pie liquorice. Candy canes wypas bear claw lollipop cupcake jelly. Apple pie halvah pastry jelly beans. Gingerbread jelly beans bonbon sweet roll. Biscuit powder lemon drops brownie. Chocolate gingerbread jelly-o icing lemon drops macaroon gingerbread. Jelly-o oat cake icing gummi bears bear claw carrot cake cookie chocolate. Cake gingerbread liquorice bear claw gingerbread tart tart. Bear claw brownie gummies faworki powder macaroon. Sweet roll cake gummi bears pie croissant. Sugar plum chocolate bar cookie wafer liquorice. Marzipan lollipop jelly icing. Donut jelly beans jelly.".split(/\./).map(&:strip)
#   @sentence_lines ||= "Hamburger andouille cow sirloin. Swine shank beef filet mignon meatloaf. Sirloin capicola pork chop ball tip ham hock pig tail, tri-tip kielbasa filet mignon beef ground round meatball. Shankle spare ribs t-bone, jerky pork belly strip steak chicken chuck corned beef. Short ribs jerky tenderloin corned beef frankfurter. Shank filet mignon turducken meatloaf. Ham hock strip steak filet mignon, flank shank corned beef pig prosciutto capicola. Ham hock flank biltong, turkey pork chop rump corned beef. Tenderloin fatback short loin, tri-tip pancetta biltong pork beef ribs sirloin corned beef sausage ground round capicola. Pastrami salami filet mignon beef ribs ball tip, tail turducken pork loin ribeye. Chicken tri-tip shankle, jowl shoulder ball tip chuck meatloaf jerky spare ribs shank cow. Tenderloin drumstick leberkas pastrami sausage. Turkey andouille fatback short ribs bacon t-bone. Shank turkey hamburger, chuck beef ribs chicken short ribs jowl. Swine meatloaf turducken ham hock, brisket shank ground round kielbasa filet mignon tenderloin bresaola pork belly beef. Capicola spare ribs tenderloin bacon rump, tri-tip short loin prosciutto leberkas pig ribeye. Tail meatball andouille, ham hock speck flank cow boudin rump ground round hamburger pancetta. Turducken short ribs pork belly, jowl strip steak kielbasa spare ribs turkey ham meatloaf ground round sausage ham hock meatball. Kielbasa sirloin rump, biltong ribeye chicken meatball strip steak. Jerky hamburger ball tip shank short ribs chuck beef ribs. Brisket pork chicken kielbasa, andouille turducken filet mignon hamburger tail strip steak ribeye. Meatball meatloaf strip steak tongue. Corned beef salami swine sirloin bresaola. Pork loin short loin bresaola, frankfurter turducken pork belly salami filet mignon shankle pastrami sausage pancetta. Pork belly turducken turkey pork chop, shankle pig boudin pancetta. Corned beef shank venison, hamburger tail jerky biltong tongue ball tip. Ham hock frankfurter swine pork belly.".split(/\./).map(&:strip)
#   
#   lines = sentence_text ? @sentence_lines : @comment_lines 
#   text = ''
#   (rand(4)+1).times { text << (lines[rand(lines.size)]+". ") }
#   text
# end
# 
# def comment_text
#   random_text(false)
# end
# 
# def sentence_text
#   random_text(true)
# end

def make_sentence
  user_id = random_user().id
  params = { :round_id => @round.to_param, :user_id => user_id }
  FactoryGirl.create(:sentence, params) 
end

def make_picture
  user_id = random_user().id
  if Rails.env.production?
    pic = FactoryGirl.create(:picture) # prevent dumping images to s3
  else
    pic = FactoryGirl.create(:picture, :with_file) 
  end
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


@ammar = FactoryGirl.create(:user, :name => 'Ammar Almakzumi', :friend_ids_csv => '2')
FactoryGirl.create(:authorization, :user_id => @ammar.id, :provider => 'facebook', :uid => '535058569')
@users << @ammar
print '.'

@ben   = FactoryGirl.create(:user, :name => 'Ben Babics', :friend_ids_csv => '3')
FactoryGirl.create(:authorization, :user_id => @ben.id, :provider => 'facebook', :uid => '500032277')
@users << @ben
print '.'

@brad  = FactoryGirl.create(:user, :name => 'Brad Chase', :friend_ids_csv => '2')
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

print "\n  ** Rounds (public) "

@rounds = []

20.times do 
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



##########################################
############ Private Rounds ##############
##########################################

print "\n  ** Rounds (private) "

@users.each do |user|
  @round = FactoryGirl.create(:round, user_id: user.id, :private => true)

  # build two slides for round
  if [true,false].sample
    make_sentence 
    make_picture 
  else
    make_picture 
    make_sentence 
  end

  # invite other users
  users = @users.clone
  users.delete(user)
  users.each do |u|
    FactoryGirl.create(:invitation, user_id:user.id, invited_user_id:u.id, round_id:@round.id)
  end

  @round.save

  print '.'
end



puts "\n** Done seeding"
