class AddIndexToTypeOnSlides < ActiveRecord::Migration
  def change
    add_index :slides, :type

  end
end
