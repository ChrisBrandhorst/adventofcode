TARGET_COLOR = "shiny gold"

RULE_FORMAT = /^([\w\s]+) bags? contain (.*)\.$/
CONTAINED_FORMAT = /(\d+) ([\w ]+) bag/

def get_containers(input, color)
  containers = input.keys.select{ |k| input[k].keys.include?(color) }
  containers | containers.map{ |c| get_containers(input, c) }.flatten
end

def get_contained(input, color)
  input[color].sum{ |k,v| v + get_contained(input, k) * v }
end

start = Time.now
input = File.readlines("input")
  .map{ |r| r.match(RULE_FORMAT).captures }
  .to_h
  .transform_values{ |v|
    v.scan(CONTAINED_FORMAT)
      .map{ |s| s.reverse }
      .to_h.transform_values(&:to_i)
  }
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = get_containers(input, TARGET_COLOR).count
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = get_contained(input, TARGET_COLOR)
puts "Part 2: #{part2} (#{Time.now - start}s)"