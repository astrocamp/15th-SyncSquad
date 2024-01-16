# frozen_string_literal: true

require 'httparty'
class LinePayService
  def initialize
    @merchant_id = Rails.application.credentials.line_pay[:merchant_id].to_s
    @merchant_key = Rails.application.credentials.line_pay[:merchant_key]

    @uri = 'https://sandbox-api-pay.line.me'
  end

  def request_payment
    headers = {
      'Content-Type' => 'application/json',
      'X-LINE-ChannelId' => @merchant_id,
      'X-LINE-ChannelSecret' => @merchant_key
    }
    confirm_url = Rails.env.production? ? 'https://www.syncsquad.online' : 'http://localhost:5000'

    body = {
      productName: '升級為VIP',
      amount: 699,
      currency: 'TWD',
      confirmUrl: confirm_url,
      orderId: SecureRandom.uuid
    }

    response = HTTParty.post("#{@uri}/v2/payments/request", headers:, body: body.to_json)

    return unless response.code == 200

    response
  end
end
