# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = Room.public_rooms
    @room = Room.new
    @users = User.all_except(current_user)
    render 'index'
  end

  def create
    @room = Room.create(name: params['room']['name'])

    # @room = Room.new(room_params)
    # if @room.save
    # 	redirect_to rooms_path, notice: 'Created new ChatRoom!'
    # else
    # 	render :new
    # end
  end

  def show
    find_room
    # Get user without current_user
    @single_room = Room.find(params[:id])
    @rooms = Room.public_rooms
    @room = Room.new
    @users = User.all_except(current_user)

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    render 'index'
  end

  def edit
    find_room
  end

  def update
    find_room
    if @room.update
      redirect_to rooms_path, notice: 'Updated ChatRoom Success!'
    else
      render :edit
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

  def find_room
    @room = Room.find_by(id: params[:id])
  end
end
