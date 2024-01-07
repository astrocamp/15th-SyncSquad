# frozen_string_literal: true

class UsersController < ApplicationController
  # 公司建立
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

  def index
    @users = User.where(company_id: current_company.id)
  end

  def import
    file = params[:file]
    if file.nil? || file.content_type != 'text/csv'
      return redirect_to users_import_path,
                         notice: t('import.please_choose_file')
    end
    CsvImportUsersService.new.call(file, current_company.id)
    redirect_to users_import_records_path, notice: t('import.data_import_process')
  end

  def records
    @import_records = Importrecord.order(created_at: :desc).page(params[:page]).per(10)
  end

  def company_params
    params.require(:company)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  # 單人聊天
  def show
    @user = User.find(params[:id])
    @users = User.all_except(current_user)

    @new_room = Room.new
    @room = Room.public_rooms
    @room_name = get_name(@user, current_user)
    @single_room = Room.find_by(name: @room_name) || Room.create_private_room([@user, current_user], @room_name)
    @private_groups = Room.joins(:participants)
                          .where(sort: 2,
                                 participants: { user_id: current_user.id })
    @message = Message.new
    @messages = @single_room.messages.order(:created_at)
    render 'rooms/index'
  end

  private

  def get_name(user1, user2)
    user = [user1, user2].sort
    "private_#{user[0].id}_#{user[1].id}"
  end
end
