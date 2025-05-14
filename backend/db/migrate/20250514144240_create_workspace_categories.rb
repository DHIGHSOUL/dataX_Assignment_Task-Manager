class CreateWorkspaceCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :workspace_categories do |t|
      t.string :name
      t.string :color
      t.references :workspace, null: false, foreign_key: true

      t.timestamps
    end
  end
end
