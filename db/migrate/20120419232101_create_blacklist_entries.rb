class CreateBlacklistEntries < ActiveRecord::Migration
  def change
    create_table :blacklist_entries, :id => false do |t|
      t.string :user_id
      t.string :blocked_user_id

      t.timestamps
    end
    add_index :blacklist_entries, :user_id
  end
end
