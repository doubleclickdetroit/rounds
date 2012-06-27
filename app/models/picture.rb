class Picture < Slide 
  if Rails.env.production?
    has_attached_file :file,
      path: ':attachment/:id/:style.:extension',
      storage: :s3,
      s3_credentials: AWS::CREDENTIALS,
      default_url: '/assets/rails.png'
  else
    has_attached_file :file, path: './public/system/:attachment/:id/:style.:extension', default_url: '/assets/rails.png'
  end

  def self.get_aws_credentials
    # security token service
    sts = AWS::STS.new(AWS::CREDENTIALS) 
    # todo ^ keep this instance somewhere?
    sts.new_session()
  end

  def content
    file.url
  end
end
