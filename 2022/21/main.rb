start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.match(/^(\w+): ((\d+)|(\w+) (.) (\w+))$/).captures }
  .inject({}){ |m,l| m[l[0]] = l[2] ? l[2].to_f : [l[3],l[4].to_sym,l[5]]; m }
puts "Prep: #{Time.now - start}s"

def calc(input, target = "root")
  todo = input.keys
  vals = todo.inject({}){ |m,l| m[l] = nil; m }
  until todo.empty?

    k = todo.shift
    if vals[k].is_a?(Float)
      next
    elsif input[k].is_a?(Float)
      vals[k] = input[k]
    elsif vals[input[k][0]].is_a?(Float) && vals[input[k][2]].is_a?(Float)
      if k == target
        return [vals[input[k][0]], vals[input[k][2]]]
      else
        vals[k] = vals[input[k][0]].send( input[k][1], vals[input[k][2]] )
      end
    else
      todo << k
    end

  end
end


start = Time.now
sol = calc(input)
part1 = sol.sum.to_i
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

# Find upper bound
until sol[0] - sol[1] < 0
  l = input["humn"]
  input["humn"] = (input["humn"] * 2).floor.to_f
  r = input["humn"]
  sol = calc(input)
end

# Binary search
until sol[0] - sol[1] == 0
  input["humn"] = ((l + r) / 2).floor.to_f
  sol = calc(input)

  if sol[0] > sol[1]
    l = input["humn"]
  elsif sol[0] < sol[1]
    r = input["humn"]
  end
end

part2 = input["humn"].to_i
puts "Part 2: #{part2} (#{Time.now - start}s)"