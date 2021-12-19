require 'matrix'
require 'set'

@rot_x = Matrix[[1,0,0],[0,0,-1],[0,1,0]]
@rot_y = Matrix[[0,0,1],[0,1,0],[-1,0,0]]
@rot_z = Matrix[[0,-1,0],[1,0,0],[0,0,1]]

@all_transformations = nil
def all_transformations
  @all_transformations ||= [
    Matrix[[1,0,0],[0,1,0],[0,0,1]],
    @rot_x,
    @rot_x * @rot_x,
    @rot_x * @rot_x * @rot_x,

    @rot_z * @rot_z,
    @rot_z * @rot_z * @rot_x,
    @rot_z * @rot_z * @rot_x * @rot_x,
    @rot_z * @rot_z * @rot_x * @rot_x * @rot_x,

    @rot_z,
    @rot_z * @rot_y,
    @rot_z * @rot_y * @rot_y,
    @rot_z * @rot_y * @rot_y * @rot_y,

    @rot_z * @rot_z * @rot_z,
    @rot_z * @rot_z * @rot_z * @rot_y,
    @rot_z * @rot_z * @rot_z * @rot_y * @rot_y,
    @rot_z * @rot_z * @rot_z * @rot_y * @rot_y * @rot_y,

    @rot_y,
    @rot_y * @rot_z,
    @rot_y * @rot_z * @rot_z,
    @rot_y * @rot_z * @rot_z * @rot_z,

    @rot_y * @rot_y * @rot_y,
    @rot_y * @rot_y * @rot_y * @rot_z,
    @rot_y * @rot_y * @rot_y * @rot_z * @rot_z,
    @rot_y * @rot_y * @rot_y * @rot_z * @rot_z * @rot_z
  ]
end


class Scanner

  attr_reader :index, :beacons, :location

  def initialize(i, beacons)
    @index = i
    @beacons = beacons
    @location = Vector[0,0,0]
  end

  def distances
    @distances ||= beacons.inject({}) do |ds,a|
      beacons.each{ |b| ds[[a,b]] = (b-a).r unless a == b }
      ds
    end
  end

  def trans!(transform, translate)
    @distances = nil
    @location = translate
    @beacons = @beacons.map{ |b| transform * b + translate }
  end

  def distance_to(other)
    a, b = self.location, other.location
    ((a[0] - b[0]) + (a[1] - b[1]) + (a[2] - b[2])).abs
  end

end


start = Time.now
scanners = File.read("input", chomp: true)
  .split("\n\n")
  .each_with_index.map{ |s,i|
    Scanner.new(
      i, s
        .split("\n")[1..-1]
        .map{ |l| Vector[*l.split(',').map(&:to_i)] }
    )
  }
puts "Prep: #{Time.now - start}s"


start = Time.now

known_scanners = [scanners[0]]
unknown_scanners = scanners[1..-1]

until unknown_scanners.empty?
  known_scanners.each do |known_scanner|
    unknown_scanners.each do |unknown_scanner|
      
      shared_distances = known_scanner.distances.values & unknown_scanner.distances.values
      if shared_distances.size >= (12-1) * 12 / 2

        known_pair = known_scanner.distances.detect{ |k,v| v == shared_distances.first }.first
        unknown_pair = unknown_scanner.distances.detect{ |k,v| v == shared_distances.first }.first
        known_dist = known_pair[1] - known_pair[0]

        unknown_scanner.distances.keys.each do |k,l|
          if transform = all_transformations.detect{ |t| t * (l - k) == known_dist }
            translate = known_pair[1] - transform * l
            unknown_scanner.trans!(transform, translate)
            unknown_scanners.delete(unknown_scanner)
            known_scanners << unknown_scanner
            break
          end
        end

      end

    end
  end
end

part1 = known_scanners.map(&:beacons).flatten.uniq.size
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = known_scanners.combination(2).map{ |a,b| a.distance_to(b) }.max
puts "Part 2: #{part2} (#{Time.now - start}s)"