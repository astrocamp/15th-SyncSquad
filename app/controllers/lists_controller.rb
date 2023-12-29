# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :find_project, only: %i[new create]
  before_action :find_list, only: %i[ edit update destroy]

  def index
    @lists = Project.find(params[:project_id]).lists
  end

  def new
    @new_list = @project.lists.build
  end

  def create
    @new_list = @project.lists.build(list_params.merge(color: '#3778EA'))

    if @new_list.save
      redirect_to @project, success: '列表創建成功'
    else
      render :new
    end
  end

  def sort
    @list = List.find(params[:list_id])
    @list.update(row_order_position: params[:row_order_position])
    # debugger
  end

  def edit; end

  def update
    if @list.update(list_params)
      redirect_to project_path(@list.project.id), success: '列表更新成功'
    else
      render :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to project_path(@list.project.id)
  end

  private

  def find_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:title, :color, :delete_at, :row_order)
  end

  def find_project
    @project = Project.find(params[:project_id])
  end
end
