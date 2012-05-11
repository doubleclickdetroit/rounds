class CreateBallots < ActiveRecord::Migration
  def change
    create_table :ballots do |t|
      t.references :slide
      t.integer :fid
      t.integer :vote

      t.timestamps
    end
    add_index :ballots, :slide_id
    add_index :ballots, :fid
  end
end
