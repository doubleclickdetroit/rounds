class CreateBlacklistEntries < ActiveRecord::Migration
  def change
    create_table :blacklist_entries do |t|
      t.integer :user_id
      t.integer :blocked_user_id

      t.timestamps
    end
    add_index :blacklist_entries, :user_id
  end
end
