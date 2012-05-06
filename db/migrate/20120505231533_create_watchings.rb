class CreateWatchings < ActiveRecord::Migration
  def change
    create_table :watchings do |t|
      t.references :slide
      t.integer :fid

      t.timestamps
    end
    add_index :watchings, :slide_id
    add_index :watchings, :fid
  end
end
