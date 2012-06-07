object @user

attributes :id, :name, :image_path

node :slides do
  partial("slides/index", :object => @slides)
end

node :comments do
  partial("comments/index", :object => @comments)
end

node :ballots do
  partial("ballots/index", :object => @ballots)
end

