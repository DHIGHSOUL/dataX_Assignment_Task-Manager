class InvitationCode < ApplicationRecord
  belongs_to :workspace

  validates :code, presence: true, uniqueness: true
  validates :used, inclusion: { in: [true, false] }
end
