class AddFidToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :fid, :integer
    add_index :rounds, :fid

  end
end
