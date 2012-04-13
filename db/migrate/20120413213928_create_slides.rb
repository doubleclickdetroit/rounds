class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.references :round

      t.timestamps
    end
    add_index :slides, :round_id
  end
end
