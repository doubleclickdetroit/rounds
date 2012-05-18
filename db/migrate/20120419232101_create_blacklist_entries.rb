class CreateBlacklistEntries < ActiveRecord::Migration
  def change
    create_table :blacklist_entries, :id => false do |t|
      t.string :fid
      t.string :blocked_fid

      t.timestamps
    end
    add_index :blacklist_entries, :fid
  end
end
