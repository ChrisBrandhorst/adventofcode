RULE_FORMAT = /^(\d+)-(\d+) (\w): (\w+)$/
MIN = 0
MAX = 1
CHAR = 2
PASS = 3

start = Time.now
input = File.readlines("input")
  .map{ |r| r.match(RULE_FORMAT).captures }
  .each{ |r| r[MIN] = r[MIN].to_i; r[MAX] = r[MAX].to_i }
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.select{ |r| r[PASS].count(r[CHAR]).between?(r[MIN], r[MAX]) }.size
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.select{ |r| (r[PASS][r[MIN] - 1] == r[CHAR]) ^ (r[PASS][r[MAX] - 1] == r[CHAR]) }.size
puts "Part 2: #{part2} (#{Time.now - start}s)"