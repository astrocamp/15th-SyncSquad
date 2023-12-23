# frozen_string_literal: true

class UsersController < Devise::RegistrationsController
  def new
    @user = User.new
  end

  def create
    @company = Company.find(params[:company_id])
    @user = @company.users.build(user_params) # 創建與公司關聯的用戶
    if @user.save
      redirect_to root_path, notice: '員工建立成功'
    else
      redirect_to root_path, alert: '員工建立失敗'
    end
  end

  def company_params
    params.require(:company)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user = User.all_expext(current_user)

    @room = Room.new
    @rooms = Room.bublic_rooms
    @room_name = get_name(@user, current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room(@user, current_user)
  
    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    render 'rooms/index'
  end

  private
    def get_name(user1, user2)
      user = [user1, user2].sort
      "private_#{user[0].id}_#{user[1].id}"
    end
end
