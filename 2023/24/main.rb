require 'z3'

start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l.split(' @ ').map{ _1.split(', ').map(&:to_i) } }
puts "Prep: #{Time.now - start}s"


start = Time.now

input.each do |stone|
  pv,dv = stone
  a = dv[1].to_f / dv[0]
  b = pv[1] - pv[0] * a
  stone << [a,b]
end

area = (200000000000000..400000000000000)
part1 = input.combination(2).filter_map.count do |(pva,dva,(a,c)),(pvb,dvb,(b,d))|
  x = (d-c) / (a-b)
  y = a * (d-c)/(a-b) + c
  future = (x >= pva[0]) ^ (dva[0] < 0) && (x >= pvb[0]) ^ (dvb[0] < 0)
  future && area.include?(x) && area.include?(y)
end
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

solver = Z3::Solver.new
px, py, pz = Z3.Real("px"), Z3.Real("py"), Z3.Real("pz")
dx, dy, dz = Z3.Real("dx"), Z3.Real("dy"), Z3.Real("dz")

input[0,3].each_with_index do |h,i|
  hpx, hpy, hpz = h[0]
  hdx, hdy, hdz = h[1]
  t = Z3.Real("t#{i}")

  solver.assert( hpx + hdx * t == px + dx * t )
  solver.assert( hpy + hdy * t == py + dy * t )
  solver.assert( hpz + hdz * t == pz + dz * t )
end

if solver.satisfiable?
  model = solver.model
  part2 = [
    model[px].to_s.to_i,
    model[py].to_s.to_i,
    model[pz].to_s.to_i
  ].sum
else
  part2 = nil
end

puts "Part 2: #{part2} (#{Time.now - start}s)"