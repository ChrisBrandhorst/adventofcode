require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

def get_grid(input, mode, target)
  intcode = Intcode.new(input)
  beam = []

  last_x_min = 0
  last_x_max = 0

  beam_count = 0

  0.step do |y|
    beam << []

    this_x_min = nil
    row_done = false

    x = last_x_min
    loop do
      coords = [x,y]
    
      intcode.reset!.run do |op,out|
        if op == :in
          coords.shift
        elsif out == 1 && this_x_min.nil?
          beam[y][x] = '#'
          this_x_min = last_x_min = x
          x = [last_x_max, x].max
        elsif out == 0 && !this_x_min.nil?
          last_x_max = x - 1
          beam[y][last_x_max] = '#'
          row_done = true
        end
      end
      
      beam_count += last_x_max - last_x_min + 1 if row_done
      break if row_done || x > last_x_max + 2

      x += 1
    end

    if mode == :fit && this_x_min && beam[y][this_x_min] == '#' && beam[y-(target-1)] && beam[y-(target-1)][this_x_min+(target-1)] == '#'
      return this_x_min * 10000 + y - (target - 1)
    elsif mode == :height && beam.size == target
      break
    end
  end
  
  beam_count
end

start = Time.now
part1 = get_grid(input, :height, 50)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = get_grid(input, :fit, 100)
puts "Part 2: #{part2} (#{Time.now - start}s)"