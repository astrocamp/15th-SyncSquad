# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, only: %i[show update destroy edit kanban_view calendar_view]
  before_action :find_current_user_affiliated_projects, only: %i[index kanban_view calendar_view]
  before_action :find_company_projects, only: %i[index]
  before_action :search_project, only: %i[update create]

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

  def create
    @project = current_user.affiliated_projects.build(project_params.merge(owner: current_user))
    current_user.affiliated_projects << @project
    flash.now[:success] = t('projects.create_success')
  end

  def show
    @tasks = @project.tasks

    respond_to do |format|
      format.html {
        case session[:__last_view__]
        when 'kanban' then render action: 'kanban_view'
        when 'calendar' then render action: 'calendar_view'
        else render action: 'kanban_view'
        end
      }
      format.json { render json: @tasks }
    end
  end

  def kanban_view
    session[:__last_view__] = 'kanban'
  end

  def calendar_view
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

  def find_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :owner_id, :delete_at)
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
end
