data = File.readlines("input").map(&:chomp).map{ |id| id.split('') }

check = { 2 => 0, 3 => 0 }
data.each do |id|
  counts = id.map{ |c| id.count(c) }
  check[2] += 1 if counts.include?(2)
  check[3] += 1 if counts.include?(3)
end

puts "Part 1: #{check[2] * check[3]}"

data_ord = data.map{ |id| id.map(&:ord) }
(0...data_ord.size).each do |i|
  (i+1...data_ord.size).each do |j|

    diff = data_ord[i].each_with_index.map{ |c,i| c - data_ord[j][i] }

    if diff.reject{ |c| c == 0 }.size == 1
      res = data[i].select.with_index{ |c,i| diff[i] == 0 }.join
      puts "Part 2: #{res}" 
      break
    end
    
  end
end