class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :fid
      t.integer :invited_fid
      t.references :round
      t.boolean :accepted, :default => false

      t.timestamps
    end
    add_index :invitations, :fid
    add_index :invitations, :invited_fid
    add_index :invitations, :round_id
  end
end
