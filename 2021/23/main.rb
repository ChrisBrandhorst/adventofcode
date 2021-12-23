require 'set'

$possible_pos = [0,1,3,5,7,9,10]
$room_pos = {'A' => 2, 'B' => 4, 'C' => 6, 'D' => 8}
$step_costs = {'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000}

class Burrow

  attr_reader :rooms
  attr_reader :room_size
  attr_reader :room_count
  attr_reader :hall
  attr_reader :cost
  attr_reader :route

  def self::build(input)
    Burrow.new( input[2..-2].map{ |l| l.scan(/[A-D\.]/) }.transpose, input[1][1..-2].chars.map{|c|c=='.'?nil:c} )
  end

  def initialize(rooms, hall = nil, cost = 0, route = [])
    @rooms = rooms.is_a?(Hash) ? rooms : "ABCD".chars.each_with_index.inject({}){ |res,(c,i)| res[c] = rooms[i].map{|c|c=='.'?nil:c}; res }
    @room_size = @rooms.first.size
    @room_count = @rooms.size
    @hall = hall || [nil] * (@room_count * 2 - 1 + 4)
    @cost = cost
    @route = route
  end

  def clone
    Burrow.new(
      @rooms.inject({}){|r,(k,v)|r[k]=v.clone;r},
      @hall.clone,
      @cost,
      @route.clone
    )
  end

  def eql?(other)
    @rooms == other.rooms && @hall == other.hall
  end

  def ==(other)
    self.eql?(other)
  end

  def hash
    (@rooms.values.flatten + @hall).hash
  end

  def visualize
    room_rows = @rooms.values.transpose
    [
      '#' * (@room_count * 2 - 1 + 6),
      '#' + @hall.map{ |i| i || '.' }.join + '#',
      '###' + room_rows.first.map{ |a| a || '.' }.join('#') + '###',
      room_rows[1..-1].map{ |r| '  #' + r.map{ |a| a || '.' }.join('#') + '#' },
      '  ' + '#' * (@room_count * 2 - 1 + 2),
    ].flatten.join("\n")
  end

  def done?
    @rooms.all?{ |k,v| v.uniq == [k] }
  end

  def can_enter?(a, r)
    room = @rooms[r]
    a == r && (room.compact.empty? || room.uniq == [nil,a])
  end

  def add_cost(c)
    @cost += c
  end

  def possible_steps
    ret = []

    # Room -> *
    @rooms.each do |a,r|
      next if r.uniq == [nil]
      next if r.uniq == [a]
      next if r.uniq == [nil,a]

      fp = $room_pos[a]

      # Room -> room
      move_i = r.count(nil)
      move_a = r[move_i]

      needs_move = a != move_a
      room_free = self.can_enter?(move_a, move_a)
      if needs_move && room_free
        tp = $room_pos[move_a]
        range = Range.new(*[fp,tp].sort)
        if hall[range].uniq.compact.empty?
          new_burrow = self.clone
          new_burrow.move!(a, move_a, self)
          ret << new_burrow
        end

      end

      # Room -> Hall
      $possible_pos.each do |tp|
        range = Range.new(*[fp,tp].sort)
        if hall[range].uniq.compact.empty?
          new_burrow = self.clone
          new_burrow.move!(a, tp, self)
          ret << new_burrow
        end
      end
    end

    # Hall -> room
    @hall.each_with_index do |a,fp|
      next if a.nil?
      next if !self.can_enter?(a, a)

      tp = $room_pos[a]
      range = tp < fp ? (tp..fp-1) : (fp+1..tp)

      if hall[range].uniq.compact.empty?
        new_burrow = self.clone
        new_burrow.move!(fp, a, self)
        ret << new_burrow
      end
    end

    ret
  end

  def move!(from, to, prev)
    if from.is_a?(Integer)
      # Hall -> Room
      room = @rooms[to]
      to_i = room.count(nil) - 1
      room[to_i] = to
      @hall[from] = nil
      tp = $room_pos[to]
      steps = (from-tp).abs + to_i + 1
      @cost += steps * $step_costs[to]
      @route << prev
    elsif to.is_a?(Integer)
      # Room -> Hall
      room = @rooms[from]
      from_i = room.count(nil)
      move_a = room[from_i]
      fp = $room_pos[from]
      room[from_i] = nil
      @hall[to] = move_a
      steps = Range.new(*[fp,to].sort).size + from_i
      @cost += steps * $step_costs[move_a]
      @route << prev
    else
      # Room -> Room
      from_room = @rooms[from]
      to_room = @rooms[to]
      from_i = from_room.count(nil)
      to_i = to_room.count(nil) - 1
      from_room[from_i] = nil
      to_room[to_i] = to
      fp = $room_pos[from]
      tp = $room_pos[to]
      steps = Range.new(*[fp,tp].sort).size + from_i + to_i + 1
      @cost += steps * $step_costs[to]
      @route << prev
    end
  end

end


def run(input)
  burrow = Burrow::build(input)

  running_states = [burrow]
  best_state = nil
  seen_states = {}

  until running_states.empty?
    state = running_states.pop
    seen_states[state] = state.cost
    
    state.possible_steps.each do |ns|
      next unless best_state.nil? || ns.cost < best_state.cost
      if ns.done?
        best_state = ns
      elsif seen_states[ns].nil? || seen_states[ns] > ns.cost
        running_states << ns
      end
    end
    
  end

  best_state.cost
end


start = Time.now
input = File.readlines("input", chomp: true)
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = run(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = run(input[0..2] + ["  #D#C#B#A#","  #D#B#A#C#"] + input[3..4])
puts "Part 2: #{part2} (#{Time.now - start}s)"