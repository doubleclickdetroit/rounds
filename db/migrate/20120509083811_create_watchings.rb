class CreateWatchings < ActiveRecord::Migration
  def change
    create_table :watchings do |t|
      t.integer :round_id
      t.string :fid

      t.timestamps
    end
    add_index :watchings, :round_id
    add_index :watchings, :fid
  end
end
