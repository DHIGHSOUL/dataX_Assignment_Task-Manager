class WorkspaceCategory < ApplicationRecord
  belongs_to :workspace

  has_many :tasks
end
