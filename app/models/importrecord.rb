# frozen_string_literal: true

class Importrecord < ApplicationRecord
  has_one_attached :file
end
