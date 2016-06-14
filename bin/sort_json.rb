#!/usr/bin/env ruby

require 'json'

class SortJson
  attr_reader :raw

  def initialize(str)
    @raw = JSON.parse str
  end

  def sort
    process_hash @raw
  end

  def process_array(val)
    arry = []

    val.each do |item|
      arry.push(process_value(item))
    end

    arry
  end

  def process_hash(dict)
    hash = {}

    dict.keys.sort.each do |key|
      hash[key] = process_value(dict[key])
    end

    hash
  end

  def process_value(val)
    if ! val.respond_to?(:each)		# non collection
      val
    elsif val.class == Array
      process_array(val)
    elsif val.class == Hash
      process_hash(val)
    else
      raise "INVALID JSON VALUE: #{val}"
    end
  end
end


if __FILE__ == $0
  sorter = SortJson.new(ARGF.read)
  puts JSON.pretty_generate(sorter.sort)
end
