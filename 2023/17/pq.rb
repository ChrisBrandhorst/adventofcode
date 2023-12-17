require_relative '../util/priority_queue.rb'

q = PriorityQueue.new

p q

q << [[0, 0], 12]
q.pop
q << [[1, 0], 15]
q << [[0, 1], 14]
q.pop
q << [[2, 0], 15]
q << [[1, 1], 16]

p q
q.pop
p q