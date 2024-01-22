# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :limit, only: %i[import]
  def import
    file = params[:file]
    if file.nil? || file.content_type != 'text/csv'
      return redirect_to users_import_path,
                         notice: t('import.please_choose_file')
    end

    CsvImportUsersService.new.call(file, current_company.id, current_user&.id)

    redirect_to users_import_path, notice: t('import.processing')
  end

  def records
    @import_records = Importrecord
                      .where(company_id: current_company.id)
                      .order(created_at: :desc)
                      .page(params[:page]).per(10)
  end

  # 單人聊天
  def show
    @user = User.find(params[:id])
    @users = User.where(company: current_user.company).all_except(current_user)

    @single_chat = Room.joins(:participants)
                       .where(room_type: 'single_room',
                              participants: { user_id: current_user.id })
    @room = Room.new
    @rooms = Room.where(room_type: 'public_room', company: current_user.company)
    @room_name = get_name(@user, current_user)
    @single_room = Room.find_by(name: @room_name) || Room.create_private_room(current_user, [@user, current_user],@room_name)
    @unread_count = @single_room.unread_messages_count(current_user)

    @private_groups = Room.joins(:participants)
                          .where(room_type: 'private_room',
                                 participants: { user_id: current_user.id })

    visit = RoomVisit.find_or_initialize_by(user_id: @current_user.id, room_id: @single_room.id)
    visit.last_visited_at = Time.current
    visit.save if visit.changed?

    @message = Message.new

    @messages = @single_room.messages.includes(:user).order(:created_at)

    render 'rooms/index'
  end

  private

  def get_name(user1, user2)
    user = [user1, user2].sort
    "private_#{user[0].id}_#{user[1].id}"
  end

  def limit
    return if current_company.advanced_import?

    redirect_to orders_path, notice: t('orders.refer')
  end
end
