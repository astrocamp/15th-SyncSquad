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

  def destroy
    edit?
  end
end
