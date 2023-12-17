require '../util/grid'
require 'set'

start = Time.now
input = File.readlines("input", chomp: true)
contrap = Grid.new(input.map(&:chars))
puts "Prep: #{Time.now - start}s"


def energize!(contrap, start_pos, start_dir)
  beams = [[start_pos, start_dir]]
  beam_hist = Set.new
  energized = []

  until beams.empty?
    pos, dir = beam = beams.pop
    next if !contrap.within?(pos)
    energized << pos
    (posx, posy), (dirx, diry) = pos, dir
    tile = contrap[pos]

    if tile == "." || tile == "|" && diry != 0 || tile == "-" && dirx != 0
      nba = [[posx+dirx,posy+diry],dir]
    else
      case tile
      when "/"
        ndir = [-dir[1],-dir[0]]
        nba = [[posx+ndir[0],posy+ndir[1]],ndir]
      when "\\"
        ndir = [dir[1],dir[0]]
        nba = [[posx+ndir[0],posy+ndir[1]],ndir]
      when "|"
        nba = [[posx,posy-1],[0,-1]]
        nbb = [[posx,posy+1],[0,1]]
      when "-"
        nba = [[posx-1,posy],[-1,0]]
        nbb = [[posx+1,posy],[1,0]]
      end
    end

    beams << nba if beam_hist.add?(nba)
    beams << nbb if !nbb.nil? && beam_hist.add?(nbb)
  end

  energized.uniq
end


start = Time.now
contrap = Grid.new(input.map(&:chars))
part1 = energize!(contrap, [0,0], [1,0]).size
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
starts = (0...contrap.col_count).inject([]) do |s,i|
  s + [
    [[i,0],[0,1]],
    [[0,i],[1,0]],
    [[i,contrap.row_count-1],[0,-1]],
    [[contrap.col_count-1,i],[-1,0]]
  ]
end
part2 = starts.map{ energize!(contrap, _1, _2).size }.max
puts "Part 2: #{part2} (#{Time.now - start}s)"