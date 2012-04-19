class AddFidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fid, :integer

  end
end
