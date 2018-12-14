data = "110201"
data_i = data.to_i

recipes = [3,7]
last = recipes.dup
elf1 = 0
elf2 = 1

part1, part2 = false
0.step do |i|

  new_recipes = (recipes[elf1] + recipes[elf2]).to_s
  new_recipes.split('').each do |r|
    recipes << r.to_i
    last << r.to_i
    last.shift while last.size > data.size + 1
  end

  elf1 = (elf1 + recipes[elf1].to_i + 1) % recipes.size
  elf2 = (elf2 + recipes[elf2].to_i + 1) % recipes.size

  puts "Part 1: #{recipes.slice(data_i, 10).join('')}" if recipes.size == data_i + 10

  if last.join('').index(data)
    puts "Part 2: #{recipes.join('').index(data)}"
    break
  end

end