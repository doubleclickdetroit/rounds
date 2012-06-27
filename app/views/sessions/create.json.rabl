object @user
attributes :id

node(:unread_invitations_count) { @user.own(Invitation).where(read:false).count }
node(:watchings_count)          { @user.own(Watching).count }

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
  {
    notice: @user.messages[:notice],
    system: @user.messages[:system]
  }
end
