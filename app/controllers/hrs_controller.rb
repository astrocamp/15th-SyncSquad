class HrsController < ApplicationController
  before_action :find_user, only: [:update] 
  #before_action :authenticate_user! 
  #before_action :authorize_hr!

  def index
    @users = User.order(id: :desc)
    @user = User.new 
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to hrs_path, notice: 'User created' 
    else
      redirect_to hrs_path, alert: 'Unable to create user'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to hrs_path, notice: 'User updated' 
    else
      redirect_to hrs_path, alert: 'Unable to update user'
    end
  end

  private

  def authorize_hr!
    redirect_to root_path, alert: "Access Denied" unless current_user.hr?
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :company_id)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
