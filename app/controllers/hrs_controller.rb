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
      redirect_to hrs_path, notice: '員工新增成功'
    else
      redirect_to hrs_path, alert: '無法新增員工'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to hrs_path, notice: '員工資料更新'
    else
      redirect_to hrs_path, alert: '員工更新失敗'
    end
  end

  def destroy
    @user.destroy
    redirect_to hrs_path, alert: '刪除離職員工'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :company_id)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
