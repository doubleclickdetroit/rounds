class Picture < Slide 
  has_attached_file :file #, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  def content
    file.url
  end
end
