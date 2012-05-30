if @round_lock
  object @round_lock
else
  attributes :id, :user_id, :round_id, :created_at

  if @build_subscription
    node(:subscription) do |round_lock| 
      channel = "/api/rounds/#{@round_id || round_lock.round.id}/lock" 
      PrivatePub.subscription(channel: channel)
    end
  end
end
