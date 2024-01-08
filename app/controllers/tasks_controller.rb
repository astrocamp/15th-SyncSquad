# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]
  before_action :find_list, only: %i[new create]

  def show; end

  def sort
    @task = Task.find(params[:task_id])
    @task.update(row_order_position: params[:row_order_position], list_id: params[:list_id])
    head :no_content
  end

  def new
    @task = @list.tasks.new
  end

  def create
    @project = @list.project
    @task = @list.tasks.build(task_params)
    if @task.save
      flash.now[:success] = t('.success')
    else
      flash.now[:alert] = t('.not_saved')
    end
  end

  def edit; end

  def update
    @project = @task.project
    if @task.update(task_params)
      redirect_to task_path(@task)
      flash.now[:success] = t('.success')
    else
      render :edit
    end
  end

  def destroy
    @project = @task.project
    @task.destroy
    flash.now[:success] = t('.success')
  end

  private

  def task_params
    params.require(:task)
          .permit(:title, :description, :priority, :start_at, :estimated_complete_at, :user_id)
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def find_list
    @list = List.find(params[:list_id])
  end
end
