class AddUploadedToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :uploaded, :boolean, default: false
  end
end
