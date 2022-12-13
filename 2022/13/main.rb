start = Time.now
$/*=2 # Set global line delimiter to \n\n
input = File.readlines("input", chomp: true)
  .map{ |l| l.split.map{ |i| eval(i) } }
  .flatten(1)
puts "Prep: #{Time.now - start}s"


DIV_0 = [[2]]
DIV_1 = [[6]]

def compare(a,b)
  a_is_int, b_is_int = a.is_a?(Integer), b.is_a?(Integer)
  if a_is_int && b_is_int
    a < b ? true : (a > b ? false : nil)
  elsif !a_is_int && !b_is_int
    (0...[a.size,b.size].max).each do |i|
      a_has, b_has = !a[i].nil?, !b[i].nil?
      if a_has && b_has
        c = compare(a[i], b[i])
        return c if !c.nil?
      else
        return b_has
      end
    end
    nil
  else
    a = [a] if a_is_int
    b = [b] if b_is_int
    compare(a, b)
  end
end


start = Time.now
part1 = input.each_slice(2).with_index.sum{ |(a,b),i| compare(a, b) ? i + 1 : 0 }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
packets = input + [DIV_0, DIV_1]

until ((0...packets.size-1).inject(0) do |r,i|
  a, b = packets[i,2]
  in_order = compare(a, b)
  if !in_order
    packets[i] = b
    packets[i+1] = a
    r += 1
  end
  r
end) == 0; end

part2 = (packets.index(DIV_0) + 1) * (packets.index(DIV_1) + 1)
puts "Part 2: #{part2} (#{Time.now - start}s)"