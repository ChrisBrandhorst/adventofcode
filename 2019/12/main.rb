input = File.readlines("input")

POS_FORMAT = /<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/
AXES = (0..2)

class Moon

  attr_accessor :pos, :vel, :pos_i, :vel_i

  def initialize(x,y,z)
    @pos = [x, y, z]
    @vel = [0, 0, 0]

    @pos_i = @pos.clone
    @vel_i = @vel.clone
  end

  def pot_en
    @pos.map(&:abs).sum
  end

  def kin_en
    @vel.map(&:abs).sum
  end

  def energy
    pot_en * kin_en
  end

end

moons = input.map{ |r| r.match(POS_FORMAT){ |m| Moon.new(*m.captures.map(&:to_i) ) } }

def get_start_state(moons, axis)
  moons.map{ |m| [m.pos_i[axis], m.vel_i[axis]] }
end

def get_state(moons, axis)
  moons.map{ |m| [m.pos[axis], m.vel[axis]] }
end

def run(moons, part)
  cycle_steps = {}
  1.step do |i|

    # Gravity
    moons.combination(2).each do |r,s|
      AXES.each do |a|
        if r.pos[a] > s.pos[a]
          s.vel[a] += 1
          r.vel[a] -= 1
        elsif r.pos[a] < s.pos[a]
          s.vel[a] -= 1
          r.vel[a] += 1
        end
      end
    end

    # Velocity
    moons.each_with_index do |m,mi|
      AXES.each{ |a| m.pos[a] += m.vel[a] }
    end

    # Solutions
    case part

    when 1
      return moons.map(&:energy).sum if i == 1000

    when 2
      AXES.each{ |a| cycle_steps[a] = i if cycle_steps[a].nil? && get_state(moons, a) == get_start_state(moons, a) }
      return cycle_steps.values.reduce(1, :lcm) if cycle_steps.size == AXES.size

    end

  end
end

start = Time.now
part1 = run(moons, 1)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = run(moons, 2)
puts "Part 2: #{part2} (#{Time.now - start}s)"