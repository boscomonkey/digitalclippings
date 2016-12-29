#!/usr/bin/env ruby

# csv_to_json.rb
#
# Converts a CSV into a JSON usable by index.html.


require 'csv'
require 'json'


if __FILE__ == $0

  fname = ARGV[0]
  if fname.nil?
    STDERR << "USAGE: #{$0} CSV_FILE"
    exit 1
  end

  csv = CSV.open fname, headers:true
  obj = {}
  csv.each {|row|
    entry = {}
    csv.headers.each {|key|
      entry[key] = row[key]
    }

    key = entry.delete 'key'
    obj[key] = entry
  }

  puts JSON.pretty_generate(obj)

end
