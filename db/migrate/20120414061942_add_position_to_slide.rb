class AddPositionToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :position, :integer

  end
end
