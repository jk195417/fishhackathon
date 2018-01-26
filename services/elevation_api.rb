module ElevationAPI
  class << self
    attr_accessor :key, :max_retry_times
  end
  self.key = ENV['elevation_key']
  self.max_retry_times = 0

  def self.request_url(lat, lng)
    "https://maps.googleapis.com/maps/api/elevation/json?locations=#{lat},#{lng}&key=#{key}"
  end

  def self.request(lat, lng)
    retries ||= 0
    url = request_url(lat, lng)
    JSON.parse(HTTP.get(url).body.to_s).dig('results', 0).fetch('elevation')
  rescue StandardError => e
    if (retries += 1) < max_retry_times
      retry
    else
      message = -> { "lat: #{lat}, lng: #{lng}, elevation error: #{e}" }
      App.logger.error { message.call }
      raise message.call
    end
  end
end
