require_relative '../util/time'
require_relative '../util/grid'
require 'set'

def prep
  input = File.readlines("input", chomp: true).map(&:chars)
  Grid.new(input)
end

def get_course(track)
  pos, fin = track.detect("S"), track.detect("E")
  course = [pos]
  until pos == fin
    pos = track.adj_coords(pos).detect{ |c| track[c] != "#" && c != course[-2] }
    course << pos
  end
  Hash[course.zip (0...course.size)]
end

def part1(track)
  course = get_course(track)
  
  cuts = []
  track.each do |c,v|
    next if v != "#"
    check_x_1 = course[[c[0] - 1, c[1]]]
    check_x_2 = course[[c[0] + 1, c[1]]]
    check_y_1 = course[[c[0], c[1] - 1]]
    check_y_2 = course[[c[0], c[1] + 1]]

    if check_x_1 && check_x_2
      cuts << (check_x_1 - check_x_2).abs - 2
    elsif check_y_1 && check_y_2
      cuts << (check_y_1 - check_y_2).abs - 2
    end
  end

  cuts
    .tally
    .sum{ |k,v| k >= 100 ? v : 0 }
end

def count_cheats(track, max_dist = 2)
  course = get_course(track)
  course.inject(0) do |saved,(c,i)|
    (-max_dist..+max_dist).each do |dx|
      ry = max_dist - dx.abs
      (-ry..ry).each do |dy|
        md = dx.abs + dy.abs
        next if md < 2
        fc = [c[0]+dx,c[1]+dy]
        next if course[fc].nil?
        s = course[fc] - course[c] - md
        saved += 1 if s >= 100
      end
    end
    saved
  end
end

track = time("Prep", false){ prep }
time("Part 1a"){ part1(track) }
time("Part 1b"){ count_cheats(track, 2) }
time("Part 2"){ count_cheats(track, 20) }
