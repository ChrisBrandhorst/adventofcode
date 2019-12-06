require_relative 'dijkstra'

input = File.readlines("input").map{ |l| l.strip.split(")") }

class SpaceObject

  attr_reader :code
  attr_reader :parent
  attr_reader :orbitee

  def initialize(code)
    @code = code
    @orbitee = []
  end

  def << (obj)
    @orbitee << obj unless @orbitee.include?(obj)
  end

  def parent=(obj)
    @parent = obj
  end

  def inspect
    "Parent: #{@parent.nil? ? "-" : @parent.code}, Orbitee: [#{@orbitee.map{ |o| o.code }.join(",")}]"
  end

  def neighbours
    if @parent.nil?
      @orbitee
    else
      @orbitee + [@parent]
    end
  end

  def distance_to(other)
    1
  end

end

def count_orbits(obj, start = 0)
  start + obj.orbitee.sum{ |o| count_orbits(o, start + 1) }
end

start = Time.now
objects = {}
input.each do |orb|
  code = orb[0]
  orbitee_code = orb[1]

  obj = objects[code] || SpaceObject.new(code)
  orbitee = objects[orbitee_code] || SpaceObject.new(orbitee_code)

  obj << orbitee
  orbitee.parent = obj

  objects[code] = obj
  objects[orbitee_code] = orbitee
end
puts "Building: #{Time.now-start}s"

start = Time.now
part1 = count_orbits(objects["COM"])
puts "Part 1: #{part1} (#{Time.now-start}s)"

start = Time.now
part2 = dijkstra_shortest_path(objects.values, objects["YOU"].parent, objects["SAN"].parent).size - 1
puts "Part 2: #{part2} (#{Time.now-start}s)"