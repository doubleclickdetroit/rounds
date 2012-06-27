class Picture < Slide 
  if Rails.env.production?
    has_attached_file :file,
      path: ':attachment/:id/:style.:extension',
      storage: :s3,
      s3_credentials: Rails.root.join('config','aws_s3.yml')
  else
    has_attached_file :file, path: './public/system/:attachment/:id/:style.:extension'
  end

  def self.get_aws_credentials
    # security token service
    sts = AWS::STS.new(AWS::CREDENTIALS) 
    sts.new_session()
  end

  def content
    file.url
  end
end
