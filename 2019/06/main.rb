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

end

objects = {}

input.each do |orb|
  code = orb[0]
  orbitee_code = orb[1]

  obj = objects[code] || SpaceObject.new(code)
  orbitee = objects[orbitee_code] || SpaceObject.new(orbitee_code)

  orbitee.parent = obj

  objects[code] = obj
  objects[orbitee_code] = orbitee
  obj << orbitee
end

def count_orbits(obj, start = 0)
  start + obj.orbitee.sum{ |o| count_orbits(o, start + 1) }
end

start = Time.now
part1 = count_orbits(objects["COM"])
puts "Part 1: #{part1} (#{Time.now-start}s)"

