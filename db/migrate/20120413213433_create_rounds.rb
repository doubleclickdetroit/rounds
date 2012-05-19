class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :user_id

      t.timestamps
    end
    add_index :rounds, :user_id
  end
end
