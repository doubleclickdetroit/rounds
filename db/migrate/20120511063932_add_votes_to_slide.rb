class AddVotesToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :votes, :integer, :default => 0

  end
end
