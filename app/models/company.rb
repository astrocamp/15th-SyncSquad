# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :users
  has_many :rooms
  has_many :importrecords
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true

  before_create :encrypt_password
  # 2FA 二階段驗證

  def self.login(data)
    email = data[:email]
    password = Digest::SHA256.hexdigest("*xx#{data[:password]}yy-")

    # find_by(email: email, password: password)
    find_by(email:, password:)
  end

  private

  def encrypt_password
    salted_password = "*xx#{password}yy-"
    self.password = Digest::SHA256.hexdigest(salted_password)
  end
end
