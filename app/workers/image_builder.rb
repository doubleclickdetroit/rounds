class ImageBuilder
  PATH_PREFIX = Rails.env.production? ? Rails.root.join('public') : Rails.root.join('public')

  @queue = :completed_rounds_queue

  def self.perform(round_id)
    round = Round.find round_id

    list = Magick::ImageList.new

    # todo clean this up
    # todo round.slides.order('id ASC').each do |slide|
    round.slides.each do |slide|
      case slide
      when Picture
        filepath = PATH_PREFIX.join(*slide.content[/(.+)\?/,1].split('/'))
        picture = Magick::Image.read(filepath).first
        list << picture
      when Sentence
        sentence = Magick::Image.new(300, 100) { self.background_color = "black" }
        Magick::Draw.new.annotate(sentence, 0,0,0,40, slide.content) do
          self.fill = 'white'
          self.pointsize = 24
        end
        list << sentence
      end
    end

    filepath = Rails.root.join 'image.png'

    list.append(true).write(filepath)
  end
end
