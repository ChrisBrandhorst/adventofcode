start = Time.now
input = File.readlines("input", chomp: true)
  .map{ r = _1.split; [r.first,r.last.split(",").map(&:to_i)] }
puts "Prep: #{Time.now - start}s"

def run(row, groups, row_i = 0, group_i = 0, group_len = 0, brk_group_len = 0, mem = {})
  mem_key = [
    row[row_i,row.size-row_i],
    groups,
    group_i,
    group_len
  ]
  return mem[mem_key] if mem.key?(mem_key)

  c, ret = row[row_i], 0

  # End of row && Last group is correct length && All groups are present
  if row_i == row.size && brk_group_len == groups.last && groups.size == group_i + 1 - (group_len == 0 ? 1 : 0)
    ret = 1
  end

  # Known and possible broken spring && Not more groups then needed && Group is not too long yet
  # Last two statements just make it quit faster
  if (c == "#" || c == "?") && group_i < groups.size && group_len < groups[group_i]
    ret += run(row, groups, row_i + 1, group_i, group_len + 1, group_len + 1, mem)
  end

  # Known and possible operational spring && (Current group is empty || Current is finished)
  if (c == "." || c == "?") && (group_len == 0 || group_len == groups[group_i])
    ret += run(row, groups, row_i + 1, group_i + (group_len == 0 ? 0 : 1), 0, brk_group_len, mem)
  end

  mem[mem_key] = ret
end


start = Time.now
part1 = input.sum{ |s,g| run(s.chars, g) }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.sum{ |s,g| run( ([s]*5).join("?").chars , g*5 ) }
puts "Part 2: #{part2} (#{Time.now - start}s)"