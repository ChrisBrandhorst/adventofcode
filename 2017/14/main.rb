input = "hfdlxzhv"
# input = "flqrgnkx"

def get_list_values(list, pos, length)
  (pos..pos+length-1).map{ |i| list[i % list.size] }
end

def set_list_values(list, pos, values)
  (pos..pos+values.size-1).each{ |i| list[i % list.size] = values[i - pos] }
end

def get_knot_hash(str)
  list = (0..255).to_a
  pos = 0
  skip = 0
  seq = str.chars.map(&:ord) + [17, 31, 73, 47, 23]
  64.times do |t|
    seq.each do |i|
      values = get_list_values(list, pos, i)
      values.reverse!
      set_list_values(list, pos, values)
      pos += i + skip
      skip += 1
    end
  end

  (0..16-1).map{ |t| "%02x" % list[16*t...16*(t+1)].inject(0){ |res,v| res = res ^ v } }.join
end

hashes = (0..127).map{ |i| get_knot_hash("#{input}-#{i}") }
bit_strings = hashes.map{ |h| "%0128d" % h.hex.to_s(2) }

puts "Part 1: #{bit_strings.join.scan("1").size}"

bit_arr = bit_strings.map{ |b| b.chars }
group_num = 1

bit_arr.each_with_index do |row,y|
  row.each_with_index do |val,x|
    # next if val == "0"

    top = y > 0 ? bit_arr[y-1][x] : nil
    left = x > 0 ? bit_arr[y][x-1] : nil

    # Empty
    if val == "0"
      t = 0
    # Top left
    elsif top.nil? && left.nil?
      t = group_num
    # Edges or new groups
    elsif (top.nil? || left.nil?) || (top == 0 && left == 0)
      t = (top || left).to_i
      if t == 0
        group_num += 1
        t = group_num
      end
    # Continue with left group
    elsif top == 0
      t = left
    # Continue with top group
    elsif left == 0
      t = top
    # Combine groups
    else
      group_num += 1
      t = group_num
      
      bit_arr.each_with_index do |r,j|
        r.each_with_index do |v,i|
          bit_arr[j][i] = t if (v == left || v == top)
        end
      end

    end

    bit_arr[y][x] = t

  end
end

puts "Part 2: #{bit_arr.flatten.uniq.size - 1}"