require 'httparty'
class LinePayService
  def initialize
    @merchant_id = "2002813423"
    @merchant_key = "68e4d49082a0dc9d88a6819c7037b335"
    @uri = "https://sandbox-api-pay.line.me" # 沙箱測試環境
  end
  
  def request_payment
    headers = {
      "Content-Type" => "application/json",
      "X-LINE-ChannelId" => @merchant_id,
      "X-LINE-ChannelSecret" => @merchant_key
    }
  
    body = {
      productName: "升級為VIP",
      amount: 699,
      currency: "TWD",
      confirmUrl: "http://localhost:5000/path_to_confirm_endpoint",
      orderId: SecureRandom.uuid # 生成唯一的訂單ID
		}
  
    response = HTTParty.post("#{@uri}/v2/payments/request", headers: headers, body: body.to_json)

    if response.code == 200
      response
    else
      nil # 或者您可以返回一個錯誤信息
    end
  end
end
