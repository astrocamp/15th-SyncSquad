# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  def show?
    user.company == User.find(record.owner_id).company
  end

  def edit?
    show? && user.id == record.owner_id
  end

  def update?
    edit?
  end

  def destroy?
    record.exists? { |project| user.id == project.owner_id }
  end

  def new_task?
    show?
  end

  def create_task?
    show?
  end

  def kanban?
    show?
  end

  def calendar?
    show?
  end
end
