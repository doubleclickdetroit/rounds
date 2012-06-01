collection @slides

extends('slides/show') do
  child(:user) {attributes :id, :name, :image_path} unless @skip_user
end
