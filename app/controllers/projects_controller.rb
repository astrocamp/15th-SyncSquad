# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, only: %i[show update destroy]
  before_action :find_current_user_affiliated_projects, only: %i[index show]

  def index
    @project = current_user.affiliated_projects.new
  end

  def aside_list; end

  def main_list; end

  def create
    @project = current_user.affiliated_projects.build(project_params.merge(owner: current_user))
    current_user.affiliated_projects << @project
    redirect_to projects_path, success: '專案新建成功。'
  end

  def show
    @list = @project.lists
    @new_task = Task.new
  end

  def update
    @project.update(project_params)
    redirect_to project_path(@project)
  end

  def destroy
    @project.destroy
    redirect_to projects_path, alert: '專案已刪除。'
  end

  private

  def find_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :owner_id, :delete_at)
  end

  def find_current_user_affiliated_projects
    @projects = current_user.affiliated_projects.order(id: :desc)
  end

  def find_current_user_affiliated_projects
    @projects = current_user.affiliated_projects.order(id: :desc)
  end

end
