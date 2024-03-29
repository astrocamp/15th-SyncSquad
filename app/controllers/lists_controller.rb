# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :find_project, only: %i[new create index]
  before_action :find_list, only: %i[edit update destroy]

  def index
    @lists = @project.lists
  end

  def new
    authorize @project, policy_class: ListPolicy
    @new_list = @project.lists.build
  end

  def create
    authorize @project, policy_class: ListPolicy
    @new_list = @project.lists.build(list_params)

    if @new_list.save
      flash.now[:success] = t('lists.create_success')
    else
      render :new
    end
  end

  def sort
    @list = List.find(params[:list_id])
    authorize @list
    @list.update(row_order_position: params[:row_order_position])
  end

  def edit
    authorize @list
  end

  def update
    authorize @list
    @project = @list.project
    if @list.update(list_params)
      flash.now[:success] = t('lists.update_success')
    else
      render :edit
    end
  end

  def destroy
    authorize @list
    @project = @list.project
    @list.destroy
    flash.now[:success] = t('lists.destroy_success')
  end

  private

  def find_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:title, :color, :row_order)
  end

  def find_project
    @project = Project.find(params[:project_id])
  end
end
