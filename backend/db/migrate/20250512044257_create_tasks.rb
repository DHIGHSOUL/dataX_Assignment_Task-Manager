class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.string :status, null: false, default: 'pending'
      t.datetime :due_date

      t.references :workspace, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :created_by_user, null: false

      t.timestamps
    end
  end
end
