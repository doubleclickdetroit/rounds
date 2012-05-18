class AddFidToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :fid, :string
    add_index :rounds, :fid

  end
end
