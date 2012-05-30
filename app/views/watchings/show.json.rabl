object @watching

attributes :id, :user_id, :round_id, :created_at

unless @dont_build_subscription 
  # todo save this as attribute?
  node(:subscription) {|watching| PrivatePub.subscription(channel: "/api/rounds/#{@round_id || watching.round.id}")}
end
