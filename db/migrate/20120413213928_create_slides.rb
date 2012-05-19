class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.integer :user_id
      t.references :round

      t.timestamps
    end
    add_index :slides, :user_id
    add_index :slides, :round_id
  end
end
