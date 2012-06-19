Resque::Server.use(Rack::Auth::Basic) do |user, password|
  # todo
  Rails.env.production? ? user == 'doubleclickdetroit' && password == 'zabraboof' : true
end
