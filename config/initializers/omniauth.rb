Rails.application.config.middleware.use OmniAuth::Builder do
  # todo 
  # provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :facebook, '239810862786452', '1f7532d3d9dfaefd114d1c6ef0e7519b',
           :scope => 'read_friendlists', :display => 'popup'
end
