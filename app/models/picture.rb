class Picture < Slide 
  if Rails.env.production?
    has_attached_file :file,
      path: ':attachment/:id/:style.:extension',
      storage: :s3,
      s3_credentials: Rails.root.join('config','s3.yml')
  else
    has_attached_file :file
  end

  def content
    file.url
  end
end
