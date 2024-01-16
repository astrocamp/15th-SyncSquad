# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    room = Room.where(room_type: 'pravite_room')
               .joins(:participants)
               .where(participants: { user: current_user })
               .distinct
    authorize room, :create_message?, policy_class: RoomPolicy

    @message = current_user.messages.create(body: msg_params[:body], room_id: params[:room_id])
  end

  private

  def msg_params
    params.require(:message).permit(:body)
  end
end
