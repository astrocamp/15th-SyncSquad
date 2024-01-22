# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :require_login, only: %i[index]
  def index
    @order = Order.new
    authorize @order
  end

  def create
    line_pay_service = LinePayService.new
    response = line_pay_service.request_payment

    Rails.logger.info "LINE Pay response: #{response.parsed_response}"

    if response && response.parsed_response['returnCode'] == '0000'
      payment_url = response.parsed_response['info']['paymentUrl']['web']
      Rails.logger.info "Redirecting to LINE Pay at #{payment_url}"
      current_company.update(paid: true)
      redirect_to payment_url, allow_other_host: true
      flash[:success] = t('orders.create_success')

    else
      @order = Order.new
      render :index
      flash[:success] = '付款失敗！請再次確認'
    end
  end

  private

  def require_login
    return if current_company || current_user

    redirect_to root_path, alert: t('orders.login')
  end
end
