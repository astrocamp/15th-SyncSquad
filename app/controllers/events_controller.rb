class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_event, only: %i[edit update show destroy]


  def index
    @events = Event.order(id: :desc)
    @event = Event.new
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      redirect_to events_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @event.update(event_params)
    if @event.save
      redirect_to event_path
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private
  
  def event_params
    params
      .require(:event)
      .permit(:subject, :start_date, :start_time, :end_date, :end_time, :all_day_event, :description, :location, :private, :user_id)
  end

  def find_event
    @event = Event.find(params[:id])
  end


end
