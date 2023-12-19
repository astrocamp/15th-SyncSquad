class Api::V1::EventsController < ApplicationController

  def drop
    @event.update(event_params)
  end

  private

  def find_event
    @event = Event.find(params[:id])
  end
end
