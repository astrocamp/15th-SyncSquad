# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def show?
    user.company == User.find(record.list.project.owner_id).company
  end

  def sort?
    show?
  end

  def new?
    user.company == User.find(record.project.owner_id).company
  end

  def create?
    new?
  end

  def edit?
    show?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def update_location?
    edit?
  end
end
