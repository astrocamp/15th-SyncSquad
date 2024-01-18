# frozen_string_literal: true

class UsersController < ApplicationController
  def import
    file = params[:file]
    if file.nil? || file.content_type != 'text/csv'
      return redirect_to users_import_path,
                         notice: t('import.please_choose_file')
    end
    CsvImportUsersService.new.call(file, current_company.id, current_user&.id)
    redirect_to users_import_records_path, notice: t('import.data_import_process')
  end

  def records
    @import_records = Importrecord.where(company_id: current_company.id).order(created_at: :desc).page(params[:page]).per(10)
  end

  # 單人聊天
  def show
    @user = User.find(params[:id])
    @users = User.where(company: current_user.company).all_except(current_user)

    @room = Room.new
    @rooms = Room.where(room_type: 'public_room', company: current_user.company)
    @room_name = get_name(@user, current_user)
    @single_room = Room.find_by(name: @room_name) || Room.create_private_room(current_user, [@user, current_user],
                                                                              @room_name)
    @private_groups = Room.joins(:participants)
                          .where(room_type: 'private_room',
                                 participants: { user_id: current_user.id })
    @message = Message.new

    begin
      @single_room = Room.create_private_room(current_user, [@user, current_user],
                                              @room_name) || Room.find_by!(name: @room_name)
    rescue ActiveRecord::RecordNotFound
      not_found
      return
    end

    @messages = @single_room.messages.includes(:user).order(:created_at)

    @rooms = current_user.rooms
    authorize @rooms, :show_private_room?, policy_class: RoomPolicy
    render 'rooms/index'
  end

  private

  def get_name(user1, user2)
    user = [user1, user2].sort
    "private_#{user[0].id}_#{user[1].id}"
  end
end
