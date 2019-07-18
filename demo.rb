# frozen_string_literal: true
#!/usr/bin/env ruby

$:.unshift "#{File.dirname(__FILE__)}/lib"

require 'json'
require 'psych'
require 'face_data_source'
require 'face_data_destination'

pre_process do
  puts "----- BEGIN #{Time.now} ----"
end

config = Psych.safe_load(File.read('database.yml'))

source FaceDataSource, config['source']

transform do |row|
  row[:id] = row.fetch(:face_id)
  feature = JSON.parse(row.fetch(:feature)).map { |e| e.round(6) }
  row_feature = "{#{feature.join(', ')}}"
  row[:feature] = row_feature
  row
end

DESTINATION_URL  = 'postgresql://wqn@localhost:5432/face_compare_demo'
destination FaceDataDestination, DESTINATION_URL

post_process do
  puts "---- END #{Time.now} ----"
end
