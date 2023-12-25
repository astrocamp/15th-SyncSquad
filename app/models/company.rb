class Company < ApplicationRecord

    validates :name, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, confirmation: true

    before_create :encrypt_password
  # 2FA 二階段驗證

  private

  def encrypt_password
    salted_password = "*xx#{self.password}yy-"
    self.password = Digest::SHA256.hexdigest(salted_password)
  end
end
