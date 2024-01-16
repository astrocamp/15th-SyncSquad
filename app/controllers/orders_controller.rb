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
      redirect_to payment_url, allow_other_host: true
      flash[:success] = t('orders.create_success')

    else
      @order = Order.new
      render :index
      flash[:success] = '付款失敗！請再次確認'
    end
  end
end
