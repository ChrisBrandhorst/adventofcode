require 'set'

start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.scan(/\d+/).map(&:to_i) }
  .map{
    {
      id: _1[0],
      ore: {
        ore: _1[1]
      },
      clay: {
        ore: _1[2]
      },
      obs: {
        ore: _1[3],
        clay: _1[4]
      },
      geo: {
        ore: _1[5],
        obs: _1[6]
      }
    }
  }
puts "Prep: #{Time.now - start}s"

start = Time.now


def produce!(state)
  state[:m_ore] += state[:r_ore]
  state[:m_clay] += state[:r_clay]
  state[:m_obs] += state[:r_obs]
  state[:m_geo] += state[:r_geo]
end

def bfs(blueprint, start_state, max_time)

  q = [start_state]
  final_states = []

  max_r_ore = [blueprint[:ore][:ore], blueprint[:clay][:ore], blueprint[:obs][:ore], blueprint[:geo][:ore]].max
  max_r_clay = blueprint[:obs][:clay]
  max_r_obs = blueprint[:geo][:obs]

  visited = Set.new

  until q.empty?
    state = q.shift.dup

    vstate = state.dup
    vstate.delete(:time)
    next if visited.include?(vstate)
    visited << vstate

    # Time
    state[:time] += 1

    # Time is up
    if state[:time] == max_time
      produce!(state)
      final_states << state
      next
    end

    # Split
    bs = nil
    if state[:m_ore] >= blueprint[:geo][:ore] && state[:m_obs] >= blueprint[:geo][:obs]
      bs = state.dup
      bs[:m_ore] -= blueprint[:geo][:ore]
      bs[:m_obs] -= blueprint[:geo][:obs]
      produce!(bs)
      bs[:r_geo] += 1
      q << bs
    else
      if state[:r_obs] < max_r_obs && state[:m_ore] >= blueprint[:obs][:ore] && state[:m_clay] >= blueprint[:obs][:clay]
        bs = state.dup
        bs[:m_ore] -= blueprint[:obs][:ore]
        bs[:m_clay] -= blueprint[:obs][:clay]
        produce!(bs)
        bs[:r_obs] += 1
        q << bs
      else
        if state[:r_clay] < max_r_clay && state[:m_ore] >= blueprint[:clay][:ore]
          bs = state.dup
          bs[:m_ore] -= blueprint[:clay][:ore]
          produce!(bs)
          bs[:r_clay] += 1
          q << bs
        end
        if state[:r_ore] < max_r_ore && state[:m_ore] >= blueprint[:ore][:ore]
          bs = state.dup
          bs[:m_ore] -= blueprint[:ore][:ore]
          produce!(bs)
          bs[:r_ore] += 1
          q << bs
        end
      end
    end

    if state[:m_ore] <= max_r_ore
      produce!(state)
      q << state
    end

  end

  final_states
end


start_state = {
  time: 0,
  r_ore: 1,
  r_clay: 0,
  r_obs: 0,
  r_geo: 0,
  m_ore: 0,
  m_clay: 0,
  m_obs: 0,
  m_geo: 0
}

part1 = input.map{ |i| i[:id] * bfs(i, start_state.dup, 24).map{ _1[:m_geo] }.max }.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input[0..2].map{ |i| bfs(i, start_state.dup, 32).map{ _1[:m_geo] }.max }.inject(:*)
puts "Part 2: #{part2} (#{Time.now - start}s)"