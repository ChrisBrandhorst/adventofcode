INPUT_FORMAT = /Step (\w) must be finished before step (\w) can begin./
DURATION_BASE = 60
MAX_WORKERS = 5

class Step
  attr_reader :id, :pre, :remaining

  def initialize(id)
    @id = id
    @pre = []
    @remaining = DURATION_BASE + @id.ord - "A".ord + 1
  end

  def requires!(other)
    @pre << other
  end

  def no_requirements?
    @pre.empty?
  end

  def <=>(other)
    @id <=> other.id
  end

  def is_possible?(executed)
    (@pre - executed).empty?
  end

  def done?
    @remaining == 0
  end

  def work!
    @remaining -= 1 unless self.done?
  end

end

steps = File.readlines("input").inject({}) do |steps, l|
  req_id, step_id = l.match(INPUT_FORMAT).captures
  step = steps[step_id] ||= Step.new(step_id)
  req = steps[req_id] ||= Step.new(req_id)
  step.requires!(req)
  steps
end

queue = steps.values.select(&:no_requirements?)
finished = []
while queue.any? do
  nxt = queue.select{ |s| steps[s.id].is_possible?(finished) }.sort.first
  finished << queue.delete(nxt)
  queue += steps.values.select{ |s| s.pre.include?(nxt) }
end
puts "Part 1: #{finished.map(&:id).join('')}"

workers = steps.values.select(&:no_requirements?)
queue = []
finished = []
seconds = 0
while workers.any? do
  seconds += 1

  workers = workers.select do |w|
    w.work!
    if w.done?
      finished << w
      queue += steps.values.select{ |s| s.is_possible?(finished) && !s.done? } - workers
    end
    !w.done?
  end

  workers << queue.shift while queue.any? && workers.size < MAX_WORKERS
end
puts "Part 2: #{seconds}"