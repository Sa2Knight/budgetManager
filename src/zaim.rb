require 'json'
require 'pp'
require 'oauth'
require 'date'
require_relative 'util'
class Zaim

  API_URL = 'https://api.zaim.net/v2/'
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
  # 生リソースを出力
  #
  def show
    @resources
  end

  #
  # リソースの合計金額を取得
  #
  def total
    @resources.inject(0) {|sum, r| sum + r['amount']}
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
  # 取得期間を今月に設定
  #
  def current_month
    cm = Date.today
    @params.merge!(Util.get_monthly_date(cm))
    self
  end

  #
  # 支出一覧を取得する
  #
  def fetch
    url = Util.make_url("home/money", @params)
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

end
