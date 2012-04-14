class AddTextToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :text, :text

  end
end
