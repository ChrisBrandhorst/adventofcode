input = File.read("input")

start_count = input.size

# Remove canceled characters
canceled_count = input.scan(/\!./).size
input.gsub! /\!./, ""

# Remove garbage
input.gsub! /<.*?>/, "0"
garbaged_count = input.scan("0").size

# Change brackets
input.gsub! "{", "["
input.gsub! "}", "]"

# To array
arr = eval(input)

def get_total(a, s = 1)
  s + a.select{ |i| i.is_a?(Array) }.map{ |i| get_total(i, s + 1) }.sum
end
puts "Part 1: #{get_total(arr)}"

garbage_length = start_count - canceled_count * 2 - input.size - garbaged_count
puts "Part 2: #{garbage_length}"