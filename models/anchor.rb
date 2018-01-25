class Anchor
  Attributes = %i[lat lng group what_3_words elevation].freeze
  Attributes.each { |a| attr_accessor a }

  def initialize(lat, lng, group, what_3_words: '', elevation: '')
    @lat = lat.to_f
    @lng = lng.to_f
    @group = group.to_s
    @what_3_words = what_3_words.to_s
    @elevation = elevation.to_s
  end

  def request_what_3_words
    retries ||= 0
    url = "https://api.what3words.com/v2/reverse?coords=#{lat},#{lng}&key=#{ENV['what_3_words_key']}"
    @what_3_words = JSON.parse(HTTP.get(url).body.to_s).dig('words')
  rescue StandardError => e
    (retries += 1) < 3 ? retry : puts("#{i} what 3 words error: #{e}")
  end

  def request_elevation
    retries ||= 0
    url = "https://maps.googleapis.com/maps/api/elevation/json?locations=#{lat},#{lng}&key=#{ENV['elevation_key']}"
    @elevation = JSON.parse(HTTP.get(url).body.to_s).dig('results',0,'elevation')
  rescue StandardError => e
    (retries += 1) < 3 ? retry : puts("#{i} elevation: #{e}")
  end

  def to_csv
    Attributes.map { |e| send e }
  end

  def self.to_csv_headers
    Attributes
  end
end
