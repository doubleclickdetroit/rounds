require Rails.root.join('lib','modules','common.rb')
require 'RMagick'

class Round < ActiveRecord::Base
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator

  has_many :slides, order: 'id DESC'
  has_many :invitations
  has_one  :round_lock
  has_many :watchings
  has_one  :dib

  validates_presence_of :slide_limit

  # todo lambda needed?
  after_save :check_for_round_completion

private
  PATH_PREFIX = Rails.env.production? ? Rails.root.join('public') : Rails.root.join('public')

  # todo .env.test? bad?
  def check_for_round_completion
    build_complete_round_image if complete and !Rails.env.test?
  end

  def build_complete_round_image
    list = Magick::ImageList.new

    # todo slides.order('id ASC').each do |slide|
    slides.each do |slide|
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
