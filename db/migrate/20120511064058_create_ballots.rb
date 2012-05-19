class CreateBallots < ActiveRecord::Migration
  def change
    create_table :ballots do |t|
      t.references :slide
      t.integer :user_id
      t.integer :vote

      t.timestamps
    end
    add_index :ballots, :slide_id
    add_index :ballots, :user_id
  end
end
