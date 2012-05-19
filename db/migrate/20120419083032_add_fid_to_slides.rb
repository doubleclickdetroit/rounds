class Adduser_idToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :user_id, :string
    add_index :slides, :user_id

  end
end
