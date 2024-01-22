# frozen_string_literal: true

class HrsController < ApplicationController
  before_action :find_user, only: %i[update destroy]
  before_action :limit, only: %i[create]

  def index
    authorize current_company, policy_class: HrsPolicy
    @users = User.where(company: current_company).order(id: :desc)
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to hrs_path, success: t('hrs.creation_success')
    else
      redirect_to hrs_path, alert: t('hrs.creation_failed')
    end
  end

  def update
    if @user.update(user_params)
      redirect_to hrs_path, success: t('hrs.update_success')
    else
      redirect_to hrs_path, alert: t('hrs.update_failed')
    end
  end

  def destroy
    @user.destroy
    redirect_to hrs_path, success: t('hrs.delete_staff')
  end

  private

  def user_params
    params.require(:user)
          .permit(:email, :password, :password_confirmation, :role)
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
