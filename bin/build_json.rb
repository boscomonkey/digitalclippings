#!/usr/bin/env ruby

require 'cgi'
require 'json'
require 'uri'

class JavascriptProxy
  def initialize
    @table = {}
  end

  def multiLoad2(site, url)
    uri = URI(site)
    host = uri.host

    query = URI(url).query
    params = CGI::parse(query)
    params.delete 'amp'

    # sanity check each param to make sure it's an Array and has only one element
    params.each_pair {|key, val|
      raise "Not an array - host: #{host}, key: #{key}" unless val.is_a? Array
      raise "More than 1 elt - host: #{host}, key: #{key}" if val.length > 1

      params[key] = val.first
    }

    @table[host] = params
  end

  def to_json
    JSON.pretty_generate(@table)
  end
end

if __FILE__ == $0
  javascript = JavascriptProxy.new

  ARGF.each do |line|
    if line =~ /(javascript:multiLoad2\([^\)]+\))/
      cmd = $1.sub("javascript:multiLoad2", "javascript.multiLoad2")
      eval cmd
    end
  end

  puts javascript.to_json
end
