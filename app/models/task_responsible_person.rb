class TaskResponsiblePerson < ApplicationRecord
  belongs_to :tasks
  belongs_to :users
end
