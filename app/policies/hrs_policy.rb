class HrsPolicy < ApplicationPolicy

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    return !@record.nil? || user.is_role?('hr')
    false
  end

  def create
    index?
  end

  def update
    index?
  end

  def destroy
    index?
  end
  
end
