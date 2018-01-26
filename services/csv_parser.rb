module CSVParser
  def self.load_anchors(it, **opts)
    anchors = []
    CSV.foreach(it, headers: true) do |row|
      anchors << Anchor.new(row[opts.fetch(:lat) { 'lat' }],
                            row[opts.fetch(:lng) { 'lng' }],
                            row[opts.fetch(:group) { 'group' }],
                            what_3_words: row[opts.fetch(:what_3_words) { 'what_3_words' }],
                            elevation: row[opts.fetch(:elevation) { 'elevation' }])
    end
    anchors
  end

  def self.save_anchors(it, anchors, mode: 'w')
    CSV.open(it, mode) do |csv|
      csv << Anchor.to_csv_headers
      anchors.each do |anchor|
        csv << anchor.to_csv
      end
    end
  end
end
