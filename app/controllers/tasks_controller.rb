# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy update_location drop]
  before_action :find_list, only: %i[new create]

  def show
    authorize @task
    @comment = Comment.new
    @comments = @task.comments
    @location = @task.location
    @latitude = @task.latitude
    @longitude = @task.longitude
  end

  def drop
    @task.update(task_params)
  end

  def sort
    @task = Task.find(params[:task_id])
    authorize @task

    @task.update(row_order_position: params[:row_order_position], list_id: params[:list_id])
    head :no_content
  end

  def new
    authorize @list, policy_class: TaskPolicy
    @task = @list.tasks.new
  end

  def create
    authorize @list, policy_class: TaskPolicy
    @project = @list.project
    @task = @list.tasks.build(task_params)
    if @task.save
      flash.now[:success] = t('tasks.create_success')
    else
      flash.now[:alert] = t('tasks.create_not_saved')
      render :new
    end
  end

  def update_location
    authorize @task
    if @task.update(location_params)
      render json: { status: 'success' }
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    authorize @task
    @location = @task.location
    @latitude = @task.latitude
    @longitude = @task.longitude
  end

  def update
    authorize @task
    @project = @task.project
    if @task.update(task_params)
      flash.now[:success] = t('tasks.update_success')
      find_tasks
    else
      render :edit
    end
  end

  def destroy
    authorize @task
    @project = @task.project
    @task.destroy
    find_tasks
    flash.now[:success] = t('tasks.destroy_success')
  end

  private

  def task_params
    params.require(:task)
          .permit(:title,
                  :description,
                  :priority,
                  :started_at,
                  :ended_at,
                  :all_day_event,
                  :source,
                  :location, :user_id)
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def find_list
    @list = List.find(params[:list_id])
  end

  def location_params
    params.require(:task).permit(:latitude, :longitude)
  end

  def find_tasks
    @tasks = @project.tasks.select { |task| task[:started_at] && task[:ended_at] }.map do |task|
      { 'id' => task[:id], 'projectId' => task.project.id,
        'title' => task[:title], 'color' => task.list.color,
        'start' => task[:started_at], 'startTime' => task[:started_at],
        'end' => task[:ended_at], 'endTime' => task[:ended_at], 'allDay' => task[:all_day_event],
        'description' => task[:description].nil? ? '' : task[:description],
        'extendedProps' => { 'priority' => task[:priority], 'source' => task[:source],
                             'user_nick_name' => task.user.nil? ? '' : (task.user.nick_name unless task.user.nick_name.nil?),
                             'list_title' => task.list.title, 'color' => task.list.color } }
    end.to_json
  end
end
