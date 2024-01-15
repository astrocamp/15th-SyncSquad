# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @rooms = Room.where(room_type: 'public_room')
    @users = User.all_except(current_user)

    @private_groups = Room.joins(:participants)
                          .where(room_type: 'private_room',
                                 participants: { user_id: current_user.id })
  end

  def new
    @room = Room.new
  end

  def create
    if params[:room][:room_type] == 'private_room'
      @new_private_group = Room.new(room_params)
      @new_private_group.room_type = 'private_room'

      if @new_private_group.save
        selected_user_ids = params[:room][:user_ids] || []
        selected_user_ids << current_user.id unless
                            selected_user_ids.include?(current_user.id)

        selected_user_ids.each do |user_id|
          Participant.create(room_id: @new_private_group.id, user_id:)
        end
        @new_private_group.broadcast_if_private_group
      end
    else
      @room = Room.create(name: params['room']['name'])
    end
  end

  def show
    @single_room = Room.find(params[:id])
    @rooms = Room.where(room_type: 'public_room')
    @private_groups = Room.joins(:participants)
                          .where(room_type: 'private_room',
                                 participants: { user_id: current_user.id })
    @room = Room.new
    @users = User.all_except(current_user)
    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    render 'index'
  end
end

private

def room_params
  params.require(:room).permit(:name, :room_type)
end
