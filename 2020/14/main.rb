MASK_MATCH = /mask = ([X01]+)/
WRITE_MATCH = /mem\[(\d+)\] = (\d+)/

def processor(input)
  mem, mask = {}, nil
  input.each do |op|
    if new_mask = op.match(MASK_MATCH)
      mask = new_mask.captures.first
    else
      addr, val = op.match(WRITE_MATCH).captures.map(&:to_i)
      yield(mem, mask, addr, val)
    end
  end
  mem.values.sum
end

start = Time.now
input = File.readlines("input", chomp: true)
puts "Prep:   #{Time.now - start}s"

start1 = Time.now
part1 = processor(input) do |mem, mask, addr, val|
  mem[addr] = val.to_s(2).rjust(36, "0")
    .chars.map.with_index{ |c,i| mask[i] == 'X' ? c : mask[i] }
    .join('').to_i(2)
end
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
part2 = processor(input) do |mem, mask, addr, val|
  addr = addr.to_s(2).rjust(36, "0")
  mask.chars.each_with_index{ |c,i| addr[i] = c unless c == '0' }
  floats = (0...addr.length).find_all{ |i| addr[i] == 'X' }
  [0,1].repeated_permutation(addr.count('X')).map{ |f|
    a = addr.clone
    floats.each_with_index{ |j,i| a[j] = f[i].to_s }
    a.to_i(2)
  }.each{ |a| mem[a] = val }
end
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"













