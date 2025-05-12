class CreateInvitationCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :invitation_codes do |t|
      t.references :workspace, null: false, foreign_key: true
      t.string :code, null: false
      t.datetime :expires_at
      t.boolean :used, null: false, default: false

      t.timestamps
    end

    add_index :invitation_codes, :code, unique: true
  end
end
