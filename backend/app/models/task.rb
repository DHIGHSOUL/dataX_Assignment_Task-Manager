class Task < ApplicationRecord
  belongs_to :workspace
  belongs_to :workspace_category, class_name: 'WorkspaceCategory', foreign_key: 'workspace_category_id', optional: true

  has_many :task_assignments, dependent: :destroy
  has_many :assigned_users, through: :task_assignments, source: :user

  validates :name, presence: true
  validates :status, inclusion: { in: %w[pending in_progress completed]}

  def complete?
    status == 'completed'
  end
end
