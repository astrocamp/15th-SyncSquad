class ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_project, only: %i[show update destroy]
    # before_action :find_own_project, only: %i[:show, :edit, :update, :destroy]

    def index
        @projects = Project.order(id: :desc)
        @project = Project.new
    end

    def show
        @project = Project.find(params[:id])
    end

    def new
        render html: params
    end

    def create
        @project = Project.new(project_params)

        if @project.save
            render json: @project, status: :created, location: @project
        else
            render json: @project.errors, status: :unprocessable_entity
        end
    end

    def update
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

    def find_own_project
        @project = Project.owned_by_user(current_user).find(params[:id])
        unless @project.owner_id == current_user.id
            redirect_to projects_path, alert: 'You are not authorized to perform this action.'
        end
    end
end 
