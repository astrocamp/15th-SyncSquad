# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @room = Room.public_rooms
    @new_room = Room.new
    @users = User.all_except(current_user)
  end

  def create
    @new_room = Room.create(name: params['room']['name'])
  end

  def show
    @single_room = Room.find(params[:id])
    @room = Room.public_rooms
    @new_room = Room.new
    @users = User.all_except(current_user)

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    render 'index'
  end
end
