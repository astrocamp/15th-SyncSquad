# frozen_string_literal: true

class Company < ApplicationRecord
    validates :name, presence: true
    validates :gui, length: { is: 8 }
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, confirmation: true
    validates :hr_name, presence: true
    validates :hr_email, presence: true, uniqueness: true
    validates :hr_password, presence: true, confirmation: true
end
