class AddPrivateToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :private, :boolean

  end
end
