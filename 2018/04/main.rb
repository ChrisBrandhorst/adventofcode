require 'date'

class GuardEvent
  attr_reader :id, :date, :event

  def initialize(date, a, id, event)
    @id = id.to_i
    @date = DateTime.parse(date)
    @event = event
  end

  def <=>(other)
    @date <=> other.date
  end

  def sleep?
    @event == "falls asleep"
  end

  def wake?
    @event == "wakes up"
  end
end

class GuardSleep
  attr_reader :id, :minutes

  def initialize(id)
    @id = id
    @minutes = []
    @sleep_minutes = nil
  end
  
  def toggle!(event)
    if event.sleep?
      self.set_sleep(event)
    elsif event.wake?
      self.set_awake(event)
    end
  end

  def set_sleep(event)
    @sleep_minutes = event.date.minute
  end

  def set_awake(event)
    (@sleep_minutes..event.date.minute-1).each do |m|
      @minutes[m] ||= 0
      @minutes[m] += 1
    end
  end

  def total_minutes
    @minutes.compact.sum
  end

  def max_minute
    @minutes.any? ? @minutes.each_with_index.max{ |a,b| (a[0] || -1) <=> (b[0] || -1) }[1] : -1
  end

  def <=>(other)
    self.total_minutes <=> other.total_minutes
  end

end

EVENT_FORMAT = /^\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2})\] (Guard #(\d+))?(.*)$/

data = File.readlines("input").map{ |c| c.match(EVENT_FORMAT){ |m| GuardEvent.new(*m.captures) } }.sort

cur_guard = nil
guard_sleeps = {}
data.each do |e|
  (cur_guard = guard_sleeps[e.id] ||= GuardSleep.new(e.id)) if e.id > 0
  cur_guard.toggle! e
end

max_guard = guard_sleeps.values.max
part1 = max_guard.id * max_guard.max_minute
puts "Part 1: #{part1}"

max_guard_sleep = guard_sleeps.values.max{ |a,b| a.max_minute <=> b.max_minute }
max_minute = max_guard_sleep.max_minute
part2 = max_guard_sleep.id * max_minute
puts "Part 2: #{part2}"