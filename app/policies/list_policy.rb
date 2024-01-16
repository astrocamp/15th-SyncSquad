# frozen_string_literal: true

class ListPolicy < ApplicationPolicy
  def new?
    user.company == User.find(record.owner_id).company
  end

  def create?
    new?
  end

  def sort?
    user.company == User.find(record.project.owner_id).company
  end

  def edit?
    sort?
  end

  def update?
    sort?
  end

  def destroy?
    sort?
  end
end
