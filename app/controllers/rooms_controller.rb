# frozen_string_literal: true

class RoomsController < ApplicationController
  # 要求登入帳號
  before_action :authenticate_user!
  # 將new建立在index上
  def index
    # 找到房間is_private: false 的欄位
    @rooms = Room.public_rooms
    @room = Room.new
    # 找出除了現在登入的使用者
    @users = User.all_except(current_user)
    render 'index'
  end

  def create
    @room = Room.create(name: params['room']['name'])
  end

  def show
    # Get user without current_user
    @single_room = Room.find(params[:id])
    @rooms = Room.public_rooms
    @room = Room.new
    @users = User.all_except(current_user)

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    render 'index'
  end
end
