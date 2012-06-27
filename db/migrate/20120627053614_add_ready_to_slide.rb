class AddReadyToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :ready, :boolean, default: true
  end
end
