start = Time.now
input = File.read("input", chomp: true).chars.map{ |c| c.hex.to_s(2).rjust(c.size*4, '0') }.join
puts "Prep: #{Time.now - start}s"

def unshift(str, i, n)
  [str[i...i+n], i + n]
end

def unshift_bin(str, i, n)
  bin, i = unshift(str, i, n)
  [bin.to_i(2), i]
end

def process(str, i, part2 = false)
  packet_version, i = unshift_bin(str, i, 3)
  packet_type_id, i = unshift_bin(str, i, 3)

  ret = packet_version unless part2

  # Literal
  if packet_type_id == 4

    bin = ""
    begin
      group, i = unshift(str, i, 5)
      bin += group[1..-1]
    end until group[0] == "0"
    ret = bin.to_i(2) if part2

  # Other
  else
    length_type_id, i = unshift_bin(str, i, 1)
    sub_ret = []

    if length_type_id == 0
      sub_packet_length, i = unshift_bin(str, i, 15)
      last_i = i + sub_packet_length

      while i < last_i
        r, i = process(str, i, part2)
        sub_ret << r
      end

    else
      sub_packet_count, i = unshift_bin(str, i, 11)
      sub_packet_count.times do
        r, i = process(str, i, part2)
        sub_ret << r
      end
    end
    
    if part2
      ret = (case packet_type_id
        when 0; sub_ret.sum
        when 1; sub_ret.inject(&:*)
        when 2; sub_ret.min
        when 3; sub_ret.max
        when 5; (sub_ret[0] > sub_ret[1] ? 1 : 0)
        when 6; (sub_ret[0] < sub_ret[1] ? 1 : 0)
        when 7; (sub_ret[0] == sub_ret[1] ? 1 : 0)
      end)
    else
      ret += sub_ret.sum
    end

  end

  [ret, i]
end


start = Time.now
part1 = process(input, 0).first
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = process(input, 0, true).first
puts "Part 2: #{part2} (#{Time.now - start}s)"