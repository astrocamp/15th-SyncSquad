# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_company_users, only: %i[index show]
  before_action :find_current_company_public_rooms, only: %i[index show]

  def index
    @rooms = Room.where(room_type: 'public_room', company: current_user.company)
    @users = User.where(company: current_user.company).all_except(current_user)
    params[:tab_type] ||= 'single_chat'
    @private_groups = Room.joins(:participants)
                          .where(room_type: 'private_room',
                                 participants: { user_id: current_user.id })
    params[:tab_type] ||= 'single_chat'
  end

  def new
    @room = Room.new
  end

  def create
    if params[:room][:room_type] == 'private_room'
      @new_private_group = Room.new(room_params)
      @new_private_group.room_type = 'private_room'
      @new_private_group.company = current_user.company
      if @new_private_group.save

        user_ids_from_params = params[:room][:user_ids] || []

        selected_user_ids = User.where(id: user_ids_from_params, company_id: current_user.company_id).pluck(:id)

        selected_user_ids << current_user.id unless selected_user_ids.include?(current_user.id)

        selected_user_ids.each do |user_id|
          Participant.create(room_id: @new_private_group.id, user_id:)
        end

        @new_private_group.broadcast_if_private_group
      else
        Rails.logger.info(@new_private_group.errors.full_messages)
      end
    else
      @room = Room.create(name: params['room']['name'], company: current_user.company)
      @room.broadcast_if_public(current_user) if @room.public_room?(current_user)
    end
  end

  def show
    @single_room = Room.find(params[:id])
    @rooms = Room.where(room_type: 'public_room', company: current_user.company)
    @private_groups = Room.joins(:participants)
                          .where(room_type: 'private_room',
                                 participants: { user_id: current_user.id })
    @room = Room.new
    @users = User.where(company: current_user.company).all_except(current_user)
    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)

    @check_room = Room.find(params[:id])
    if @check_room.room_type == "public_room"
      authorize @check_room, :show_public_room, policy_class: RoomPolicy
    else
      authorize @check_room, :show_private_room?, policy_class: RoomPolicy
    end

    render 'index'
  end

  private

  def find_company_users
    @users = User.where(company: current_user.company).all_except(current_user)
  end

  def find_current_company_public_rooms
    @room = Room.where(room_type: 'public_room', company: current_user.company)
  end
end

private

def room_params
  params.require(:room).permit(:name, :room_type)
end
