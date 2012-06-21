class ChangeAcceptedToReadOnInvitations < ActiveRecord::Migration
  def change
    rename_column :invitations, :accepted, :read
  end
end
