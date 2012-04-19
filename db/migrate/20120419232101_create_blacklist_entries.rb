class CreateBlacklistEntries < ActiveRecord::Migration
  def change
    create_table :blacklist_entries, :id => false do |t|
      t.integer :user_fid
      t.integer :blocked_fid

      t.timestamps
    end
    add_index :blacklist_entries, :user_fid
  end
end
