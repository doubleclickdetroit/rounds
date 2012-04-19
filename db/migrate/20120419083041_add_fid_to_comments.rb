class AddFidToComments < ActiveRecord::Migration
  def change
    add_column :comments, :fid, :integer
    add_index :comments, :fid

  end
end
