# frozen_string_literal: true

require 'httparty'
class LinePayService
  def initialize
    @merchant_id = Rails.application.credentials.line_pay[:merchant_id].to_s
    @merchant_key = Rails.application.credentials.line_pay[:merchant_key]

    @uri = 'https://sandbox-api-pay.line.me' # 沙箱測試環境
  end

  def request_payment
    headers = {
      'Content-Type' => 'application/json',
      'X-LINE-ChannelId' => @merchant_id,
      'X-LINE-ChannelSecret' => @merchant_key
    }

    body = {
      productName: '升級為VIP',
      amount: 699,
      currency: 'TWD',
      confirmUrl: 'www.syncsquad.online' || 'http://localhost:5000/',
      orderId: SecureRandom.uuid # 生成唯一的訂單ID
    }

    response = HTTParty.post("#{@uri}/v2/payments/request", headers:, body: body.to_json)

    if response.code == 200
      response
    else
      nil # 或者您可以返回一個錯誤信息
    end
  end
end
