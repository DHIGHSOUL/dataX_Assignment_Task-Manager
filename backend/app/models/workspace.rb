class Workspace < ApplicationRecord
    has_many :user_workspaces, dependent: :destroy
    has_many :users, through: :user_workspaces

    has_many :tasks, dependent: :destroy
    has_many :categories, dependent: :destroy

    has_many :task_progresses, dependent: :destroy

    validates :name, presence: true
end
