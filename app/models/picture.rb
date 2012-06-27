class Picture < Slide 
  if Rails.env.production?
    has_attached_file :file,
      path: ':attachment/:id/:style.:extension',
      storage: :s3,
      s3_credentials: Rails.root.join('config','aws.yml')
  else
    has_attached_file :file, path: './public/system/:attachment/:id/:style.:extension'
  end

  def self.get_aws_credentials
    api_key = YAML.load_file(Rails.root.join('config','aws_s3.yml'))
    sts     = AWS::STS.new(api_key) # security token service
    sts.new_session()
  end

  def content
    file.url
  end
end
