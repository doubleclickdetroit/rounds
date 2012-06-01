collection @ballots

extends 'ballots/show' do
  child(:user) {attributes :id, :name, :image_path} unless @skip_user
end
