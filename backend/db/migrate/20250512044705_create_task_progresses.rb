class CreateTaskProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :task_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workspace, null: false, foreign_key: true
      t.integer :total_tasks, null: false, default: 0
      t.integer :completed_tasks, null: false, default: 0
      t.float :progress_rate, null: false, default: 0.0
      t.datetime :calculated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
  end
end
