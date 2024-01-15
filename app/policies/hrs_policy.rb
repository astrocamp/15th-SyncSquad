# frozen_string_literal: true

class HrsPolicy < ApplicationPolicy
  def index?
    !@record.nil? || user.role?('hr')
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end
end
