require '../util/astar.rb'
require 'set'

start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.scan(/([A-Z]{2,}).*?(\d+).*?([A-Z, ]{2,})/) }
  .inject({}){ |v,l| v[l[0][0]] = [l[0][1].to_i, l[0][2].strip.split(", ")]; v }

puts "Prep: #{Time.now - start}s"

start = Time.now


class Tunnels

  def initialize(valves)
    @valves = valves
  end

  def neighbours(v)
    @valves[v].last
  end

  def heuristic(a, b)
    1
  end

  def distance(a, b)
    1
  end

end

tunnels = Tunnels.new(input)

distances = input.keys.combination(2).inject({}) do |d,(a,b)|
  d[[a,b]] = d[[b,a]] = astar(tunnels, a, b).size - 1
  d
end

relevant_valves = input.keys.select{ input[_1].first > 0 }

@opened_sets = {}

def dfs(all_valves, relevant_valves, distances, state, max_time = 30, best_score = 0)
  
  current = state[:path].last
  path = state[:path]
  time = state[:time]
  released = state[:released]
  flow_rate = state[:flow_rate]

  # Check if over time
  if time > max_time
    released -= (time - max_time) * (flow_rate - all_valves[path.last].first)
    @opened_sets[path[1..-2]] = released
    return [released, best_score].max
  end

  # Finish last bit
  if path.size == relevant_valves.size + 1
    released += (max_time - time) * flow_rate
    @opened_sets[path[1..-1]] = released
    return [released, best_score].max
  end

  # Check if useful
  if released + (max_time - time + 1) * relevant_valves.sum{ all_valves[_1].first } < best_score
    return best_score
  end

  # Move to next nodes
  relevant_valves.each do |v|
    next if path.include?(v)

    dt, dr = 0, 0
    if all_valves[v].first > 0
      time_when_opened = distances[[current,v]] + 1
      flow_when_opened = flow_rate
      dt = time_when_opened
      dr = flow_when_opened * time_when_opened
    end

    vp = path.dup
    vp << v
    s = {
      path: vp,
      time: time + dt,
      released: released + dr,
      flow_rate: flow_rate + all_valves[v].first
    }
    best_score = dfs(all_valves, relevant_valves, distances, s, max_time, best_score)
  end

  best_score

end

part1 = dfs(input, relevant_valves, distances,{
  path: ["AA"],
  time: 0,
  released: 0,
  flow_rate: 0
})
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

part2 = nil
puts "Part 2: #{part2} (#{Time.now - start}s)"