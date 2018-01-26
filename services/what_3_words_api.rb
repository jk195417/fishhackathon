module What3WordsAPI
  class << self
    attr_accessor :key, :max_retry_times
  end
  self.key = ENV['what_3_words_key']
  self.max_retry_times = 0

  def self.request_url(lat, lng)
    "https://api.what3words.com/v2/reverse?coords=#{lat},#{lng}&key=#{key}"
  end

  def self.request(lat, lng)
    retries ||= 0
    url = request_url(lat, lng)
    JSON.parse(HTTP.get(url).body.to_s).fetch('words')
  rescue StandardError => e
    if (retries += 1) < max_retry_times
      retry
    else
      message = -> { "lat: #{lat}, lng: #{lng}, what 3 words error: #{e}" }
      App.logger.error { message.call }
      raise message.call
    end
  end
end
