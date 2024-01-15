# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, only: %i[new_task show update destroy edit kanban calendar create_task]
  before_action :find_current_user_affiliated_projects, only: %i[index kanban calendar]
  before_action :find_company_projects, only: %i[index]
  before_action :search_project, only: %i[update create]
  before_action :find_tasks, only: %i[show calendar create_task]

  def index
    @project = current_user.affiliated_projects.all # current_user projects
    @q = @projects.ransack(params[:q])
    @projects = @q.result.includes(:owner)
  end

  def aside_list; end

  def main_list; end

  def new
    @project = current_user.affiliated_projects.new
  end

  def new_task
    @started_at_value = DateTime.parse(params["startedAt"])
    @ended_at_value = DateTime.parse(params["endedAt"])
    @task = @project.tasks.new
  end

  def create
    @project = current_user.affiliated_projects.build(project_params.merge(owner: current_user))
    current_user.affiliated_projects << @project
    flash.now[:success] = t('projects.create_success')
  end

  def create_task
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash.now[:success] = '事件建立成功'
      find_project
      find_tasks
    else
      flash.now[:alert] = '事件新增失敗'
      render :new_task
    end
  end

  def show
    @params = params
    render action: session[:__last_view__] || 'kanban'
  end

  def kanban
    session[:__last_view__] = 'kanban'
  end

  def calendar
    @params = params
    session[:__last_view__] = 'calendar'
  end

  def edit; end

  def update
    @project.update(project_params)
    flash.now[:success] = t('projects.update_success')
  end

  def destroy
    @project.destroy
    redirect_to projects_path, success: t('projects.destroy_success')
  end

  private

  def new_project
    @project = current_user.affiliated_projects.new
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :owner_id)
  end

  def task_params
    params.permit(:title, :list_id, :started_at, :ended_at, :all_day_event)
  end

  def find_current_user_affiliated_projects
    @projects = current_user.affiliated_projects.order(id: :asc)
  end

  def find_company_projects
    @company = Company.find(current_user.company_id)
    @users = @company.users.ids
    @projects = Project.where(owner: @users)
  end

  def search_project
    @company = Company.find(current_user.company_id)
    @users = @company.users.ids
    @projects = Project.where(owner: @users)
    @q = @projects.ransack(params[:q])
    @projects = @q.result.includes(:owner)
  end

  def find_tasks
    @tasks = @project.tasks.select { |task| task[:started_at] && task[:ended_at] }.map do |task|
      {
        'id' => task[:id],
        'projectId' => task.project.id,
        'title' => task[:title],
        'color' => task.list.color,
        'start' => task[:started_at],
        'startTime' => task[:started_at],
        'end' => task[:ended_at],
        'endTime' => task[:ended_at],
        'allDay' => task[:all_day_event],
        'description' => task[:description].nil? ? '' : task[:description],
        'extendedProps' => {
          'priority' => task[:priority],
          'completed_at' => task[:completed_at].nil? ? '' : '✓',
          'estimated_completed_at' => task[:estimated_completed_at],
          'source' => task[:source],
          'user_nick_name' => task.user.nil? ? '' : task.user.nick_name,
          'list_title' => task.list.title,
          'color' => task.list.color,
        },
      }
    end.to_json
  end  
end
