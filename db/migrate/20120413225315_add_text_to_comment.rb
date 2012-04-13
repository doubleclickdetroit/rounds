class AddTextToComment < ActiveRecord::Migration
  def change
    add_column :comments, :text, :text

  end
end
