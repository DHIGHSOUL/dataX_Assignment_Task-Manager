class User < ApplicationRecord
    has_secure_password

    has_many :user_workspaces, dependent: :destroy
    has_many :workspaces, through: :user_workspaces

    has_many :task_assignments
    has_many :assigned_tasks, through: :task_assignments, source: :task

    has_many :created_tasks, class_name: 'Task', foreign_key: 'created_by_user_id'

    has_many :task_progresses, dependent: :destroy

    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, uniqueness: true
end