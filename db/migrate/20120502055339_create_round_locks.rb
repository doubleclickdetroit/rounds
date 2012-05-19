class CreateRoundLocks < ActiveRecord::Migration
  def change
    create_table :round_locks do |t|
      t.references :round
      t.string :user_id

      t.timestamps
    end
    add_index :round_locks, :round_id
  end
end
