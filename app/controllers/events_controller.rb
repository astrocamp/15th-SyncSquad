# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :require_login, only: %i[index new edit show]
  before_action :find_event, only: %i[show edit drop update destroy]

  def index
    @events = if current_user
                current_user.company.events.map(&:full_calendar_event)
              else
                current_company.events.map(&:full_calendar_event)
              end
    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def new
    @started_at_value = DateTime.parse(params['startedAt'])
    @ended_at_value = DateTime.parse(params['endedAt'])
    @event = Event.new
  end

  def create
    @event = current_company.events.build(event_params)
    if @event.save
      flash.now[:success] = t('calender.create_success')
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def drop
    @event.update(event_params)
  end

  def update
    if @event.update(event_params)
      flash.now[:success] = t('calender.update_success')
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    flash.now[:alert] = t('calender.deleted')
  end

  private

  def event_params
    params
      .require(:event)
      .permit(
        :subject, :started_at, :ended_at, :all_day_event, :description
      )
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def require_login
    return if current_company || current_user

    redirect_to root_path, alert: t('calender.login')
  end
end
