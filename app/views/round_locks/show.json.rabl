if @round_lock.nil?
  node(:subscription) do 
    channel = "/api/rounds/#{@round_id}/lock" 
    PrivatePub.subscription(channel: channel)
  end
else
  object @round_lock

  attributes :id, :user_id, :round_id, :created_at

  node(:created_at) {|record| record.created_at.to_s}

  if @build_subscription
    node(:subscription) do |round_lock| 
      channel = "/api/rounds/#{@round_id || round_lock.round.id}/lock" 
      PrivatePub.subscription(channel: channel)
    end
  end
end
