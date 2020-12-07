start = Time.now
input = File.read("input")
  .split("\n\n")
  .map{ |g|
    g.split("\n")
      .map{ |f| f.split('') }
  }
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.sum{ |g| g.inject(:|).count }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.sum{ |g| g.inject(:&).count }
puts "Part 2: #{part2} (#{Time.now - start}s)"