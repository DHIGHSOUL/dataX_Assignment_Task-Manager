class WorkspaceCategory < ApplicationRecord
  belongs_to :workspace

  has_many :tasks

  validates :name, presence: true
  validates :color, format: { with: /\A\h{6}\z/, message: "must be a valid hex color code" }, allow_nil: true
end
