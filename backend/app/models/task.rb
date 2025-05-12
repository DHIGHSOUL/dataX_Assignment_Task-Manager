class Task < ApplicationRecord
  belongs_to :workspace
  belongs_to :category
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by_user_id'

  has_many :task_assignments, dependent: :destroy
  has_many :assigned_users, through: :task_assignments, source: :user

  validates :name, presence: true
  validates :status, inclusion: { in: %w[pending in_progress completed]}
end
