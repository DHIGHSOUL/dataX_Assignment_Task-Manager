class JwtBlacklist < ApplicationRecord
    validates :token, presence: true, uniqueness: true
    validates :exp, presence: true
end
