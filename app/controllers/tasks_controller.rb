# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]

  def show; end

  def sort
    @task = Task.find(params[:task_id])
    @task.update(row_order_position: params[:row_order_position], list_id: params[:list_id])
    head :no_content
  end
  
  def new
    @list = List.find(params[:list_id])
    @task = @list.tasks.new
  end

  def create
    @list = List.find(params[:list_id])
    @project = @list.project
    @task = @list.tasks.build(task_params)
    if @task.save
      #redirect_to project_path(@list.project), notice: '待辦事項新增成功'
      flash.now[:success] = "待辦事項新增成功"
    else
      #redirect_to project_path(@list.project), alert: '請填入待辦事項'
      flash.now[:alert] = "請填入待辦事項"
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to project_path(@task.list.project.id)
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to project_path
  end

  private

  def task_params
    params.require(:task)
          .permit(:title, :description, :priority, :start_at, :estimated_complete_at, :user_id)
  end

  def find_task
    @task = Task.find(params[:id])
  end
end
