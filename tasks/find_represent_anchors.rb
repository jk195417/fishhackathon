require_relative '../configs/initializer'
# step 1 : load unnamed.csv to Anchors
anchors = CSVParser.load_anchors App.root_path.join('data', 'unnamed.csv'), lng: 'lon', group: 'anchor_group'

# step 2 : grouping Anchors by group, find each group's represent anchor
anchor_groups = anchors.group_by(&:group)
represent_anchors = anchor_groups.map do |group, ary|
  # avg lat, lng
  lat = ary.map(&:lat).sum / ary.length
  lng = ary.map(&:lng).sum / ary.length
  Anchor.new lat, lng, group
end

# step 3 : save represent Anchors to represent_anchors.csv
CSVParser.save_anchors App.root_path.join('data', 'represent_anchors.csv'), represent_anchors
