#!/usr/bin/env ruby
=begin
Removes all "url" fields from the following JSON:
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
  },
   ...
=end

require 'json'

instream = ARGF.read
obj = JSON.parse instream
obj.each {|key, val|
  val.delete 'url'
}
puts JSON.pretty_generate(obj)
