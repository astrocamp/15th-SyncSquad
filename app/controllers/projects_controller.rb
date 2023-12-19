# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, only: %i[show update destroy]

  def index
    @projects = current_user.affiliated_projects.order(id: :desc)
    @project = current_user.affiliated_projects.new
    @project.owner_id = current_user.id
    #
    render 'index'
  end

  def create
    #
    @project = current_user.affiliated_projects.build(project_params)
    current_user.affiliated_projects << @project
  end

  def show; end

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
end
