class AddTypeToWatching < ActiveRecord::Migration
  def change
    add_column :watchings, :type, :string
    add_index :watchings, :type

  end
end
