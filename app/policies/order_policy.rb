# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  def index?
    !user
  end
end
