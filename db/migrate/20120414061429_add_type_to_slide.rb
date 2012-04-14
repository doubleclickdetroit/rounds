class AddTypeToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :type, :string

  end
end
