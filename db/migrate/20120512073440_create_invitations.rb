class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :invited_user_id
      t.references :round
      t.boolean :accepted, :default => false

      t.timestamps
    end
    add_index :invitations, :user_id
    add_index :invitations, :invited_user_id
    add_index :invitations, :round_id
  end
end
