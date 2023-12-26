# frozen_string_literal: true

class TaskResponsiblePerson < ApplicationRecord
  belongs_to :task
  belongs_to :user
end
