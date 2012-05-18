class AddFidToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :fid, :string
    add_index :slides, :fid

  end
end
