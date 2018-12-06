input = File.readlines("input").map{ |i| i.gsub(/\n$/, "").split('') }
@input = input

def delta(dir = nil)
  {
    x: dir == 0 || dir == 2 ? dir - 1 : 0,
    y: dir == 1 || dir == 3 ? -dir + 2 : 0
  }
end

def item(pos, dir = nil)
  d = delta(dir)
  item = @input[pos[:x] + d[:x]][pos[:y] + d[:y]]
  item == ' ' ? nil : item
end

def new_pos(pos, dir)
  d = delta(dir)
  {
    x: pos[:x] + d[:x],
    y: pos[:y] + d[:y]
  }
end


pos = { x: 0, y: input[0].index('|') }
dir = 2 # 0-3: n, e, s, w

letters = ""
step_count = 0
loop do

  item = item(pos)
  break if item.nil?

  case item
  when "+"
    if dir % 2 == 0
      dir = item(pos, 1) ? 1 : 3
    else
      dir = item(pos, 0) ? 0 : 2
    end
  when /[A-Z]/
    letters << item
  end

  pos = new_pos(pos, dir)
  step_count += 1
end

puts "Part 1: #{letters}"
puts "Part 2: #{step_count}"