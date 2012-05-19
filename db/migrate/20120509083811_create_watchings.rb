class CreateWatchings < ActiveRecord::Migration
  def change
    create_table :watchings do |t|
      t.integer :round_id
      t.string :user_id

      t.timestamps
    end
    add_index :watchings, :round_id
    add_index :watchings, :user_id
  end
end
