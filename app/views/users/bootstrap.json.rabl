object @user
attributes :id

node(:invitations) do
  channel = "/api/users/#{@user.id}/invitations" 

  {
    count:        @user.own(Invitation).where(read:false).count,
    subscription: PrivatePub.subscription(channel: channel)
  }
end

node(:watchings) do
  { count: @user.own(Watching).count }
end

node(:gamification) do
  {
    points: 1_000_000,
    currency: 500,
    rank: 5
  }
end
node(:abilities) do
  {
    colors: [],
    brushes: [],
    fonts: [],
  }
end

node(:messages) do
  if @user.respond_to? :messages
    {
      notice: @user.messages[:notice],
      system: @user.messages[:system]
    }
  else 
    {}
  end
end
