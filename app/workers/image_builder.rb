class ImageBuilder
  # todo
  PATH_PREFIX = Rails.env.production? ? Rails.root.join('public') : Rails.root.join('public')
  # todo
  WRITE_PATH  = Rails.env.production? ? Rails.root.join('image.png') : Rails.root.join('image.png')

  @queue = :completed_rounds_queue

  def self.perform(round_id)
    round = Round.find round_id

    image = build_image(round)
    write_image(image)
  end

  def self.build_picture(slide)
    url     = PATH_PREFIX.join(*slide.content[/(.+)\?/,1].split('/'))
    picture = Magick::Image.read(url).first
  end

  def self.build_sentence(slide)
    # build background
    sentence = Magick::Image.new(300, 100) do
      self.background_color = "black" 
    end

    # write text to background
    Magick::Draw.new.annotate(sentence, 0,0,0,40, slide.content) do
      self.fill = 'white'
      self.pointsize = 24
    end

    # resulting Magick::Image
    sentence
  end

  def self.build_image(round)
    image_list = Magick::ImageList.new

    # todo round.slides.order('id ASC').each do |slide|
    round.slides.each do |slide|
      case slide
      when Picture
        image_list << build_picture(slide)
      when Sentence
        image_list << build_sentence(slide)
      else
        raise "Failed image generation: Round##{round.id} has Slide that is not Sentence or Picture."
      end
    end

    image_list
  end

  def self.write_image(image_list)
    image_list.append(true).write(WRITE_PATH)
  end
end
