collection @slides

extends('slides/show') do
  if @user_in_full
    child(:user) do 
      attributes :id, :name, :image_path 
    end
  end
end
