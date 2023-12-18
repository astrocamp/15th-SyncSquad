class CalendarsController < ApplicationController
  def index
    @calendars = Calendar.all
  end

  def new
    @calendar = Calendar.new
  end
end
