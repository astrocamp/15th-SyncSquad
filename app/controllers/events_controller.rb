# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :find_event, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @events = current_user.events.map(&:full_calendar_event)
    @event = Event.new
    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.new(event_params)
    # 直接for current user
    if @event.save
      redirect_to events_path, notice: '新增事件成功！'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    @event.update(event_params)
    if @event.save
      redirect_to event_path, notice: '更新事件成功！'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, alert: '事件已刪除！'
  end

  private

  def event_params
    params
      .require(:event)
      .permit(
        :subject, :start_date, :start_time, :end_date, :end_time, :all_day_event, :description, :location, :private
      )
  end

  def find_event
    @event = Event.find(params[:id])
  end
end
