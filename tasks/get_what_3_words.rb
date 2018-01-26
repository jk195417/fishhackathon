require_relative '../configs/initializer'

start_time = Time.now
errors = 0

# step 1 : load represent_anchors.csv to Anchors
anchors = CSVParser.load_anchors App.root_path.join('data', 'represent_anchors.csv')

# step 2 : use mutli threads send requests ask for what 3 words
worker = Worker.new
anchors.each do |anchor|
  next unless anchor.what_3_words.to_s.empty?
  worker.add_task do
    begin
      anchor.what_3_words = What3WordsAPI.request anchor.lat, anchor.lng
    rescue StandardError => _
      anchor.what_3_words = nil
      errors += 1
    end
  end
end
worker.work

# step 3 : save represent Anchors to represent_anchors.csv
CSVParser.save_anchors App.root_path.join('data', 'represent_anchors.csv'), anchors

end_time = Time.now
puts "Get what 3 words done\ncost times: #{end_time-start_time}s\n#{errors} errors."
