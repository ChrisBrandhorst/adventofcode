require_relative '../util/time'
require 'z3'

def prep
  File.readlines("input", chomp: true)
    .map{ |l|
      parts = l.split(" ").map{ _1[1..-2] }
      lights = parts.shift.chars.map{ _1 == "#" }
      parts.map!{ _1.split(",").map(&:to_i) }
      [
        lights,
        parts.pop,
        parts
      ]
    }
end

def shortest_path(lights, buttons)
  q = [[[false] * lights.size, 0]]

  until q.empty?
    state, steps = q.shift
    buttons.each do |bs|
      new_state = state.clone
      bs.each{ new_state[_1] = ! new_state[_1] }
      if new_state == lights
        return steps + 1
      else
        q << [new_state, steps + 1]
      end
    end
  end
end

def part1(input)
  input.sum{ |ls,_,bs| shortest_path(ls, bs) }
end

def part2(input)
  input.sum do |_,js,bs|
    solver = Z3::Optimize.new

    prs = (0...bs.size).map{ |i|
      z = Z3.Int("prs#{i}")
      solver.assert(z >= 0)
      z
    }
    solver.minimize(prs.sum)

    js.each_with_index do |v,i|
      solver.assert(
        bs.map.with_index.sum{ |b,j| b.include?(i) ? prs[j] : 0 } == v
      )
    end

    solver.satisfiable? ? prs.sum{ solver.model[_1].to_i } : nil
  end
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }