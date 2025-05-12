class CreateUserWorkspaces < ActiveRecord::Migration[8.0]
  def change
    create_table :user_workspaces do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workspace, null: false, foreign_key: true
      t.string :role, null: false, default: 'member'

      t.timestamps
    end
  end
end
