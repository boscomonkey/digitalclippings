#!/usr/bin/env ruby

=begin

Converts a JSON file into a CSV. Performs a first pass of the JSON to
figure out all the field names, and then performs another pass to
output the final CSV.

Purpose is to convert papers.json that Hilary has been editing by hand
into a canonical CSV file that she can use Excel to maintain.

{
  "www.theadobepress.com": {
    "url": "http://www.theadobepress.com/news/",
    "newspaper": "Adobe Press",
    "county_id": "San Luis Obispo"
  },
  "ledger-dispatch.com": {
    "url": "http://ledger-dispatch.com/",
    "newspaper": "Amador Ledger Dispatch",
    "county_id": "Amador"
  },
  "theava.com": {
    "url": "http://theava.com/",
    "newspaper": "Anderson Advertiser - Mendo",
    "county_id": "Mendocino"
  }
}

Becomes

key,county_id,newspaper,url
ledger-dispatch.com,Amador,Amador Ledger Dispatch,http://ledger-dispatch.com/
theava.com,Mendocino,Anderson Advertiser - Mendo,http://theava.com/
www.theadobepress.com,San Luis Obispo,Adobe Press,http://www.theadobepress.com/news/
=end

require 'csv'
require 'json'
require 'set'


if __FILE__ == $0

  instream = ARGF.read
  obj = JSON.parse instream

  # pass 1 - collect all the subkeys with the bodies
  subkeys = Set.new
  obj.each {|key, body|
    body.each {|subkey, val|
      subkeys << subkey
    }
  }

  # check for reserved subkey
  reserved_key = 'key'
  if subkeys.include?(reserved_key)
    STDERR << <<EOF
ERROR: reserved keyword "#{reserved_key}" is already in use
EOF
    exit 1
  end

  # pass 2 - output
  sorted_subkeys = subkeys.to_a.sort
  header = [reserved_key] + sorted_subkeys
  puts header.join(',')

  sorted_entries = obj.keys.sort
  sorted_entries.each {|entry|
    body = obj[entry]
    row = [entry]
    sorted_subkeys.each {|subkey|
      row << body[subkey]
    }
    puts row.join(',')
  }
end
