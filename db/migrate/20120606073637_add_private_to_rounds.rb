class AddPrivateToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :private, :boolean

  end
end
