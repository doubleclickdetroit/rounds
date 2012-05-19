class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user_id
      t.references :slide

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :slide_id
  end
end
