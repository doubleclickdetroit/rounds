class AddFidToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :fid, :integer
    add_index :slides, :fid

  end
end
