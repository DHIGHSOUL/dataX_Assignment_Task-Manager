class Category < ApplicationRecord
  belongs_to :workspace

  has_many :tasks, dependent: :nullify

  validates :name, presence: true
end
