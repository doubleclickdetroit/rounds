class Adduser_idToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :user_id, :string
    add_index :rounds, :user_id

  end
end
