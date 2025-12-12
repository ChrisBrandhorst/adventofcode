require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
    .map{ inp, out = _1.split(": ")
      [inp, out.split(" ")]
    }.to_h
end

def part1(input)
  q, path_count = ["you"], 0
  until q.empty?
    input[q.shift].each do |a|
      if a == "out"
        path_count += 1
      else
        q << a
      end
    end
  end
  path_count
end

def dfs(input, node, target, memo = {})
  return 1 if node == target
  memo[node] ||= (input[node] || []).inject(0){ _1 + dfs(input, _2, target, memo) }
end

def part2(input)
  dfs(input, "svr", "fft") *
  dfs(input, "fft", "dac") *
  dfs(input, "dac", "out") +
  dfs(input, "svr", "dac") *
  dfs(input, "dac", "fft") *
  dfs(input, "fft", "out")
end

def dfs_with_needed(input, node, target, need, nc = 0, memo = {})
  return nc / need.size if node == target
  memo[[node,nc]] ||= (input[node] || []).inject(0) do |c,n|
    c + dfs_with_needed(input, n, target, need, nc + (need.include?(n)?1:0), memo)
  end
end

def part2_with_needed(input)
  dfs_with_needed(input, "svr", "out", ["dac","fft"])
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2v1"){ part2(input) }
time("Part 2v2"){ part2_with_needed(input) }