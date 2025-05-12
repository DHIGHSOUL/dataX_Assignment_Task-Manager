class UserWorkspace < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  validates :role, presence: true
end
