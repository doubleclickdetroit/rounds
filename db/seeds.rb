puts "** Begin seeding"
def random_text
  @lines ||= "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam id vulputate leo. Suspendisse vulputate libero eu leo ornare adipiscing. Cras mattis tristique mollis. Aenean et metus neque, nec porta lacus. Sed quis semper nisl. Nunc vel mi sem, vitae imperdiet metus. Suspendisse purus metus, pulvinar ac scelerisque et, rutrum ultrices urna. Sed faucibus placerat turpis, sed luctus odio aliquam nec. Integer justo diam, rhoncus in malesuada ac, eleifend eget libero. Praesent congue suscipit urna eu semper. Vestibulum velit nisl, porta sit amet aliquam faucibus, semper vel eros. Proin arcu massa, iaculis et malesuada dignissim, egestas eu diam. Vestibulum eleifend ante id nisl sollicitudin ac faucibus diam hendrerit. Vivamus vitae ipsum dui, et tincidunt felis. Nullam posuere odio egestas sapien ornare convallis. Nullam eget mi vel lorem mollis gravida. Mauris quam velit, malesuada nec tempor ac, dapibus quis augue. Suspendisse potenti.".split(/\./).map(&:strip)

  text = ''
  (rand(4)+1).times { text << (@lines[rand(@lines.size)]+". ") }
  text
end



##########################################
################ Rounds ##################
##########################################

puts '  ** Round'

@round = FactoryGirl.create(:round)



##########################################
################ Slides ##################
##########################################

puts '    ** Slides'

def make_sentence
  params = { :round_id => @round.to_param }
  FactoryGirl.create(:sentence, params) 
end

def make_picture
  pic = FactoryGirl.build(:picture, :with_file) 
  pic.round_id = @round.to_param
  pic.save
end

6.times do |i|
  klass = i.odd? ? make_sentence : make_picture 
end



##########################################
############### Comments #################
##########################################

puts '      ** Comments'

@round.slides.each do |slide|
  (rand 4).times do
    slide.comments << FactoryGirl.create(:comment, :text => random_text)
  end
end



puts "** Done seeding"
