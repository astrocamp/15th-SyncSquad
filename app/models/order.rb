# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  validates :serial_num, uniqueness: true

  before_create :generate_serial

  private

  def generate_serial
    self.serial_num = serial_generator
  end

  def serial_generator(digits = 6)
    now = Time.current
    year = now.year
    month = format('%02d', now.month)
    day = format('%02d', now.day)
    code = SecureRandom.alphanumeric.upcase[0..digits - 1]

    "Sync#{year}#{month}#{day}#{code}"
  end
end
