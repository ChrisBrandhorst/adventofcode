input = File.readlines("input").map{ |i| i.gsub("\n", "").split(" => ") }


def variants(s)
  a = s.split("/").map(&:chars)
  base = [
    a,
    a.map(&:reverse),
    a.transpose,
    a.transpose.reverse
  ]
  (base + base.map{ _1.map(&:reverse).reverse }).uniq
end


rules = input.inject({}) do |c,v|
  variants(v[0]).each{ |i| c[i] = v[1].split("/").map(&:chars) }
  c
end


def iterate(grid, rules, iterations = 5)
  iterations.times do

    size = grid.first.size
    sqsize = size % 2 == 0 ? 2 : 3
    div = size / sqsize

    sqs = []
    (0...div).each do |i|
      (0...div).each do |j|
        sqs << grid[i*sqsize,sqsize].map{ _1[j*sqsize,sqsize] }
      end
    end

    applied = sqs.map{ rules[_1] || _1 }

    acount = applied.size
    asqsize = applied.first.size
    adiv = Math.sqrt(acount).to_i
    grid = []

    applied.each_with_index do |a,i|
      a.each_with_index do |r,j|
        gr = (i/adiv)*asqsize+j
        grid[gr] ||= []
        grid[gr] += r
      end
    end
  end

  grid.flatten.count("#")
end


grid = ".#.\n..#\n###".split("\n").map(&:chars)
puts "Part 1: #{iterate(grid, rules)}"
puts "Part 2: #{iterate(grid, rules, 18)}"