require 'json'
require 'pp'
require 'oauth'
class Zaim

  API_URL = 'https://api.zaim.net/v2/'
  PRIVATE_BUDGET   = 40000
  PRIVATE_COMMENT  = "私費"

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
    api_key       = ENV['ZAIM_API_KEY']
    api_secret    = ENV['ZAIM_API_SECRET']
    access_key    = ENV['ZAIM_ACCESS_KEY']
    access_secret = ENV['ZAIM_ACCESS_SECRET']
    @consumer = OAuth::Consumer.new(api_key, api_secret, oauth_params)
    @access_token = OAuth::AccessToken.new(@consumer, access_key, access_secret)
    @params = {}
  end

  #
  # リソースを出力
  #
  def show
    p @resources
  end

  #
  # 私費のみ取得するようにする
  #
  def privates
    @params[:comment] = PRIVATE_COMMENT
    self
  end

  #
  # 支出のみ取得するようにする
  #
  def payments
    @params[:mode] = :payment
    self
  end

  #
  # 支出一覧を取得する
  #
  def fetch
    url = make_url("home/money", @params)
    @resources = get(url)['money']
    self
  end

  private

    #
    # ZaimAPIに対してGETリクエストを送信
    #
    def get(url)
      response = @access_token.get("#{API_URL}#{url}")
      JSON.parse(response.body)
    end

    #
    # GET用のURLを生成する
    #
    def make_url(url , params)
      params.each do |k , v|
        if url.index('?').nil?
          url += "?#{k}=#{v}"
        else
          url += "&#{k}=#{v}"
        end
      end
      url_escape = URI.escape(url)
      return url_escape
    end

end
