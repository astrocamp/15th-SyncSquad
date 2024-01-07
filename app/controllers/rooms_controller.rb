# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @room = Room.public_rooms
    @users = User.all_except(current_user)
  end

  def new
    @new_room = Room.new
    @new_private_group = Room.new
    @modal_type = params[:modal_type]
  end

  def create
    if params[:room][:is_private] == "true"
      @new_private_group = Room.new(room_params)
      @new_private_group.is_private = true
      @new_private_group.sort = 2

      if @new_private_group.save
        selected_user_ids = params[:room][:user_ids] || []
        selected_user_ids << current_user.id unless
                            selected_user_ids.include?(current_user.id)

        selected_user_ids.each do |user_id|
          Participant.create(room_id: @new_private_group.id, user_id: user_id)
        end
      end
    else
      @new_room = Room.create(name: params['room']['name'])
    end
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

private

def room_params
  params.require(:room).permit(:name, :is_private)
end
