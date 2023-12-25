class Company < ApplicationRecord

    validates :name, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, confirmation: true
end
