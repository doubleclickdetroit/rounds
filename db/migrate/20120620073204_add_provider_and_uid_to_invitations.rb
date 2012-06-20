class AddProviderAndUidToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :invited_provider, :string
    add_column :invitations, :invited_uid, :string
  end
end
