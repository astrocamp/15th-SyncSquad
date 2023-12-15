class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    
  end

  private
  
  def event_params
    params
      .require(:event)
      .permit(:subject, :start_date, :start_time, :end_date, :end_time, :all_day_event, :description, :location, :private)
  end
end
