# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :find_project, only: %i[new create index]
  before_action :find_list, only: %i[edit update destroy]

  def index
    @lists = @project.lists
  end

  def new
    @new_list = @project.lists.build
  end

  def create
    @new_list = @project.lists.build(list_params.merge(color: '#3778EA'))

    if @new_list.save
      flash.now[:success] = t('lists.create_success')
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
    @project = @list.project
    if @list.update(list_params)
      flash.now[:success] = t('lists.update_success')
    else
      render :edit
    end
  end

  def destroy
    @project = @list.project
    @list.destroy
    flash.now[:success] = t('lists.destroy_success')
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
