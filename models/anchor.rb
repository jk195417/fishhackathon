class Anchor
  Attributes = %i[lat lng group what_3_words elevation].freeze
  Attributes.each { |a| attr_accessor a }

  def initialize(lat, lng, group, what_3_words: nil, elevation: nil)
    @lat = lat.to_f
    @lng = lng.to_f
    @group = group.to_s
    @what_3_words = what_3_words
    @elevation = elevation
  end

  def to_csv
    Attributes.map { |e| send e }
  end

  def self.to_csv_headers
    Attributes
  end
end
