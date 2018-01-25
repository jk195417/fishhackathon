require 'rubygems'
require 'bundler'
Bundler.require(:default)
require 'csv'
require 'yaml'
require 'json'
require_relative 'models/anchor'
require_relative 'services/worker'

# load env
env_filepath = './env.yml'
env_string = File.exist?(env_filepath) ? File.read(env_filepath) : ''
YAML.safe_load(env_string).each { |k, v| ENV[k] = v }

# use following line to read represent_anchors.csv to Anchors
# represent_anchors = read_anchors_from_csv './data/represent_anchors.csv'
def read_anchors_from_csv(it, **opts)
  anchors = []
  CSV.foreach(it, headers: true) do |row|
    anchors << Anchor.new(row[opts.fetch(:lat) { 'lat' }],
                          row[opts.fetch(:lng) { 'lng' }],
                          row[opts.fetch(:group) { 'lat' }],
                          what_3_words: row[opts.fetch(:what_3_words) { 'what_3_words' }],
                          elevation: row[opts.fetch(:elevation) { 'elevation' }])
  end
  anchors
end

# use following line to save represent Anchors to represent_anchors.csv
# save_anchors_to_csv('./data/represent_anchors.csv', represent_anchors)
def save_anchors_to_csv(it, anchors, mode: 'w')
  CSV.open(it, mode) do |csv|
    csv << Anchor.to_csv_headers
    anchors.each do |anchor|
      csv << anchor.to_csv
    end
  end
end

# step 1 : read unnamed.csv to Anchors
anchors = read_anchors_from_csv('./data/unnamed.csv', lng: 'lon', group: 'anchor_group')

# step 2 : grouping Anchors by group, find each group's represent anchor
anchor_groups = anchors.group_by(&:group)
represent_anchors = anchor_groups.map do |group, ary|
  # avg lat, lng
  lat = ary.map(&:lat).sum / ary.length
  lng = ary.map(&:lng).sum / ary.length
  Anchor.new lat, lng, group
end

# step 3 : get each represent_anchor's what 3 words and elevation
worker = Worker.new
represent_anchors.each do |anchor|
  worker.add_task do
    anchor.request_what_3_words
  end
end
worker.work
represent_anchors.each do |anchor|
  worker.add_task do
    anchor.request_elevation
  end
end
worker.work
save_anchors_to_csv('./data/represent_anchors.csv', represent_anchors)
