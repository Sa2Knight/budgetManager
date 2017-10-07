module Util

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

  #
  # 指定した日付の月の初日と最終日を戻す
  #
  def get_monthly_date(date)
    return {
      date_from: Date.new(date.year, date.month),
      date_to:   Date.new(date.year, date.month, -1),
    }
  end

  module_function :make_url
  module_function :get_monthly_date

end
