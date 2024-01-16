# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  validates :serial_num, uniqueness: true

  before_create :generate_serial

  private

  def generate_serial
    self.serial_num = serial_generator
  end

  def serial_generator(_digits = 6)
    Time.current.strftime('%Y%m%d')
    code = SecureRandom.alphanumeric(6)

    "Sync#{year}#{month}#{day}#{code}"
  end
end
