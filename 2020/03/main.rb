start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)
puts "Prep: #{Time.now - start}s"

def get_slope(grid, x, y)
  grid[y] ? grid[y][x % grid[0].size] : nil
end

def get_route(grid, dx, dy)
  x, y, route = 0, 0, []
  loop do
    slope = get_slope(grid, x, y)
    break if slope.nil?
    route << slope
    x += dx
    y += dy
  end
  route
end

start = Time.now
part1 = get_route(input, 3, 1).count('#')
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = [
  get_route(input, 1, 1),
  get_route(input, 3, 1),
  get_route(input, 5, 1),
  get_route(input, 7, 1),
  get_route(input, 1, 2)
].map{ |r| r.count('#') }.inject(&:*)
puts "Part 2: #{part2} (#{Time.now - start}s)"