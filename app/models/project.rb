class Project < ApplicationRecord
    scope :owned_by_user, ->(user) { where(user_id: user.id) }

    # Relations
    belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

    # Validates
    validates :title, presence: true
    validates :owner, presence: true
end
