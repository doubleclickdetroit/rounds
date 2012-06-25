object @user
attributes :id

node(:watchings_count) { @watchings_count }
node(:unread_invitations_cound) { @unread_invitations_cound }

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
    fonts: []
  }
end

node(:messages) do
  node(:notice) { @notice }
  node(:system) { 'Message of the day!' }
end
