require 'json'
require 'pp'
require 'oauth'
class Zaim

  API_URL = 'https://api.zaim.net/v2/'

  #
  # 初期化時にZaimAPIの利用準備を行う
  #
  def initialize
    oauth_params = {
      site: "https://api.zaim.net",
      request_token_path: "/v2/auth/request",
      authorize_url: "https://auth.zaim.net/users/auth",
      access_token_path: "https://api.zaim.net"
    }
    api_key = ENV['ZAIM_API_KEY']
    api_secret = ENV['ZAIM_API_SECRET']
    access_key = ENV['ZAIM_ACCESS_KEY']
    access_secret = ENV['ZAIM_ACCESS_SECRET']
    @consumer = OAuth::Consumer.new(api_key, api_secret, oauth_params)
    @access_token = OAuth::AccessToken.new(@consumer, access_key, access_secret)
  end

  #
  # ZaimAPIに対してPOSTリクエストを送信
  #
  def get(url)
    response = @access_token.get("#{API_URL}#{url}")
    JSON.parse(response.body)
  end

  #
  # ZaimAPIに対してPUTリクエストを送信
  #
  def put(url , params = nil)
    response = @access_token.put("#{API_URL}#{url}" , params)
    JSON.parse(response.body)
  end

end
