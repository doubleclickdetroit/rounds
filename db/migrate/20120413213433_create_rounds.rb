class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :user_id
      t.integer :slide_limit
      t.boolean :complete, default: false
      t.boolean :private,  default: false

      t.timestamps
    end
    add_index :rounds, :user_id
  end
end
