require_relative '../util/time'
require 'set'

def prep
  boxes = File.readlines("input", chomp: true)
    .map{ _1.split(",").map(&:to_i) }
  distances = boxes.combination(2).each_with_object([]) do |(a,b),dists|
    d = Math.sqrt((a[0]-b[0])**2 + (a[1]-b[1])**2 + (a[2]-b[2])**2)
    dists << [a,b,d]
  end
  [
    distances.sort{ _1[2] <=> _2[2] },
    Set.new(boxes)
  ]
end

def connect!(distances, circuits)
  a, b = distances.shift

  ca, cb = circuits[a], circuits[b]
  if ca.nil? && cb.nil?
    circuits[a] = circuits[b] = Set.new([a,b])
  elsif ca.nil?
    cb << a
    circuits[a] = cb
  elsif cb.nil?
    ca << b
    circuits[b] = ca
  elsif ca != cb
    cc = ca + cb
    cc.each{ circuits[_1] = cc }
  end

  [a, b]
end

def part1(distances)
  1000
    .times
    .each_with_object({}){ connect!(distances, _2) }
    .values
    .uniq
    .map(&:size)
    .sort[-3..-1]
    .inject(&:*)
end

def part2(distances, boxes)
  circuits = {}
  while boxes.any?
    a, b = connect!(distances, circuits)
    boxes.delete(a)
    boxes.delete(b)
  end
  a[0] * b[0]
end

distances, boxes = time("Prep", false){ prep }
time("Part 1"){ part1(distances) }
time("Part 2"){ part2(distances, boxes) }