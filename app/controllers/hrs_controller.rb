# frozen_string_literal: true

class HrsController < ApplicationController
  before_action :find_user, only: %i[update destroy]

  def index
    @users = User.order(id: :desc)
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to hrs_path, notice: t('hrs.creation_success')
    else
      redirect_to hrs_path, alert: t('hrs.creation_failed')
    end
  end

  def update
    if @user.update(user_params)
      redirect_to hrs_path, notice: t('hrs.update_success')
    else
      redirect_to hrs_path, alert: t('hrs.update_failed')
    end
  end

  def destroy
    @user.destroy
    redirect_to hrs_path, alert: t('hrs.delete_staff')
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :company_id)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
