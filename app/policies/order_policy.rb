class OrderPolicy < ApplicationPolicy
  def index?
    !user
  end
end