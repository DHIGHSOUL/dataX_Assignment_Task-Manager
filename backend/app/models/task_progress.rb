class TaskProgress < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  validates :total_tasks, :completed_tasks, numericality: {greater_than_or_equal_to: 0}
  validates :progress_rate, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0}
end
