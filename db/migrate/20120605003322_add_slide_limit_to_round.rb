class AddSlideLimitToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :slide_limit, :integer

  end
end
