require_relative '../util/time'

def prep
  File.read("input", chomp: true).split("\n\n")
    .map{ |s| s.split("\n").map{ _1.scan(/\d+/).map(&:to_i) } }
end

def solve(input, error = 0)
  input.sum do |(bax,bay),(bbx,bby),(prx,pry)|
    b = (-(prx + error) * bay + (pry + error) * bax) / (-bbx * bay + bby * bax)
    a = (pry + error - b * bby) / bay
    a * bax + b * bbx == prx + error && a * bay + b * bby == pry + error ? a * 3 + b * 1 : 0
  end
end

input = time("Prep", false){ prep }
time("Part 1"){ solve(input) }
time("Part 2"){ solve(input, 10000000000000) }