class AddFriendIdsCsvToUsers < ActiveRecord::Migration
  def change
    add_column :users, :friend_ids_csv, :string

  end
end
