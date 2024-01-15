# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    @order = Order.new
  end

  def create
    line_pay_service = LinePayService.new
    response = line_pay_service.request_payment

    Rails.logger.info "LINE Pay response: #{response.parsed_response}"

    if response && response.parsed_response['returnCode'] == '0000'
      payment_url = response.parsed_response['info']['paymentUrl']['web']
      Rails.logger.info "Redirecting to LINE Pay at #{payment_url}"
      flash[:success] = "付款成功！感谢您的購買"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to payment_url, allow_other_host: true } # 導向 LINE Pay 支付頁面
      end
      
    else
      # 處理錯誤情況，重新渲染 index 頁面
      @order = Order.new # 確保 index 頁面有 @order 變量
      flash[:success] = "付款失敗！請再次確認"
      respond_to do |format|
        format.turbo_stream # 需要一個對應的 .turbo_stream.erb 模板
        format.html { render :index } # 改為重新渲染 index 頁面
      end
    end
  end
end
