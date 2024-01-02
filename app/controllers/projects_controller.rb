# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, only: %i[show update destroy edit]
  before_action :find_current_user_affiliated_projects, only: %i[index show]

  def index
    # @project = current_user.affiliated_projects.new
    @q = Project.ransack(params[:q])
    @project = @q.result.includes(:owner)
  end

  def aside_list; end

  def main_list; end

  def new
    @project = current_user.affiliated_projects.new
  end

  def create
    @project = current_user.affiliated_projects.build(project_params.merge(owner: current_user))
    current_user.affiliated_projects << @project
    flash.now[:success] = '專案建立成功'
  end

  def show; end
  def edit; end

  def update
    @project.update(project_params)
    flash.now[:success] = '專案更新成功'
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
    @projects = current_user.affiliated_projects.order(id: :asc)
  end
end
