GROUP_SIZE = 5
data = File.readlines("input")

pots = data[0].match(/[#.]+/)[0].split('')
spread = data.slice(2...data.size).map{ |s| s.match(/([#.]+) => ([#.])/).captures }.inject({}){ |h,s| h[s.first] = s.last; h }

def next_state(pots, spread, i)
  spread[pots.slice(i-2, GROUP_SIZE).join('')] || '.'
end

def next_generation(pots, spread, first_idx)
  new_pots = [] * (pots.size - 1)
  (0..pots.size - 1).each do |i|
    new_pots[i] = next_state(pots, spread, i)
  end

  # first_plant_idx = new_pots.index('#')

  # if first_plant_idx < GROUP_SIZE-1
  #   (GROUP_SIZE-1 - first_plant_idx).times{ new_pots.unshift('.') }
  # elsif first_plant_idx > GROUP_SIZE-1
  #   (first_plant_idx - (GROUP_SIZE-1)).times{ new_pots.shift }
  # end
  # new_first_idx = first_idx + (first_plant_idx - (GROUP_SIZE-1))

  new_first_idx = first_idx #new_pots.index('#') - (GROUP_SIZE-1)

  last_plant_idx = new_pots.rindex('#')
  if last_plant_idx > new_pots.size - GROUP_SIZE
    (last_plant_idx - new_pots.size + GROUP_SIZE).times{ new_pots.push('.') }
  elsif last_plant_idx < new_pots.size - GROUP_SIZE
    (new_pots.size - GROUP_SIZE - last_plant_idx).times{ new_pots.pop }
  end

  [new_pots, new_first_idx]
end

def prosper(pots, spread, generations, first_idx)
  last = [pots, first_idx]

  generations.times do |i|
    pots, first_idx = next_generation(pots, spread, first_idx)

    if pots[pots.index('#')..pots.rindex('#')].join('') == last.first[last.first.index('#')..last.first.rindex('#')].join('')

      gen_remaining = generations - i
      first_idx_diff = 1
      plants_move = first_idx_diff * gen_remaining

      puts "Generation #{i} is same as #{i-1}"
      puts "Generations remaining: #{gen_remaining}"
      puts "First plant index: #{first_idx}"
      puts "Plants move per generation: #{first_idx_diff}"
      puts "Plants move remaining: #{plants_move}"
      
      first_idx += plants_move - 1

      break
    end
    last = [pots, first_idx]
  end

  [pots, first_idx]
end 

work_pots = ['.'] * (GROUP_SIZE-1) + pots + ['.'] * (GROUP_SIZE-1)
first_idx = -(GROUP_SIZE-1)

final, first_idx = prosper(work_pots, spread, 20, first_idx)
p final.each_index.select{ |i| final[i] == '#' }.map{ |i| i + first_idx }.sum

final, first_idx = prosper(work_pots, spread, 50000000000, first_idx)
p final.each_index.select{ |i| final[i] == '#' }.map{ |i| i + first_idx }.sum

# 2600000001872