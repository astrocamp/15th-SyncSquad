# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, only: %i[show update destroy edit]
  before_action :find_current_user_affiliated_projects, only: %i[index show]
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
    flash.now[:success] = t('.success')
  end

  def show; end
  def edit; end

  def update
    @project.update(project_params)
    redirect_to projects_path, success: t('.success')
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: t('.success')
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
