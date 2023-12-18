# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    # 紀錄訊息本體與創建訊息的房間
    @message = current_user.messages.create(body: msg_params[:body], room_id: params[:room_id])
  end

  private

  def msg_params
    params.require(:message).permit(:body)
  end
end
