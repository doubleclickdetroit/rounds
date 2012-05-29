# node(:user) { attributes :id, :name, :image_path }

node :rounds do
  partial("rounds/index", :object => @rounds)
end

node :slides do
  partial("slides/index", :object => @slides)
end

node :comments do
  partial("comments/index", :object => @comments)
end

node :ballots do
  partial("ballots/index", :object => @ballots)
end

