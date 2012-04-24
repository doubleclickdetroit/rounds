class AddInappropriateToComment < ActiveRecord::Migration
  def change
    add_column :comments, :inappropriate, :boolean

  end
end
