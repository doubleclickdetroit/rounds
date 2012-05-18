class AddFidToComments < ActiveRecord::Migration
  def change
    add_column :comments, :fid, :string
    add_index :comments, :fid

  end
end
