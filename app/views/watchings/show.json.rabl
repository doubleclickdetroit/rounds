object @watching

attributes :id, :user_id, :round_id

node(:created_at) {|record| record.created_at.to_s}

unless @dont_build_subscription 
  # todo save this as attribute?
  node(:subscription) do |watching| 
    channel = "/api/rounds/#{@round_id || watching.round.id}/watch" 
    PrivatePub.subscription(channel: channel)
  end
end
