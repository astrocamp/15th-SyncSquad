# frozen_string_literal: true

class HrsController < ApplicationController
  before_action :find_user, only: %i[update destroy]
  before_action :limit, only: %i[create]

  def index
    authorize current_company, policy_class: HrsPolicy
    @users = User.where(company: current_company).order(id: :desc)
    @user = User.new
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @user, status: :ok }
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        project = Project.create(title: I18n.t('template.project'), owner_id: @user.id)
        @user.affiliated_projects << project
        list = project.lists.create(title: I18n.t('template.list'), color: '#4299E1')
        list.tasks.create(title: I18n.t('template.task1'), started_at: Date.current, ended_at: Date.current + 1)
        list.tasks.create(title: I18n.t('template.task2'), started_at: Date.current, ended_at: Date.current + 1)
        format.html { redirect_to hrs_path, success: t('hrs.creation_success') }
        format.json { render json: @user, status: :ok }
      else
        format.html { redirect_to hrs_path, alert: t('hrs.creation_failed') }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to hrs_path, success: t('hrs.update_success') }
        format.json { render json: @user, status: :ok }
      else
        format.html { redirect_to hrs_path, alert: t('hrs.update_failed') }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to.html { redirect_to hrs_path, success: t('hrs.update_success') }
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation, :role)
          .merge(company_id: current_user ? current_user.company_id : current_company.id)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def limit
    return if current_company.add_more_users?

    redirect_to orders_path, notice: '請參考付費功能'
  end
end
