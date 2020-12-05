require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

NAT_ADDRESS = 255

class Computer

  def initialize(input, address, network)
    @intcode = Intcode.new(input)
    @network = network
    @in_buffer = [address]
    @idle = false
    @address = address
  end

  def run!(nat)
    out_buffer = []
    @intcode.run do |op,out|
      Thread.pass
      if op == :out
        out_buffer << out
        if out_buffer.size == 3
          @network[out_buffer.shift] << out_buffer
          out_buffer = []
        end
      elsif nat.done?
        nil
      else
        @idle = @in_buffer.empty?
        inp = @idle ? -1 : @in_buffer.shift
        inp
      end
    end
  end

  def <<(packet)
    @in_buffer += packet
  end

  def idle?
    @idle
  end

end

class NAT

  attr_reader :last_packet

  def initialize(computers, address)
    @computers = computers
    @address = address
    @last_packet = nil
    @ys = []
  end

  def run!
    while !done?
      Thread.pass
      if @last_packet && @computers.all?(&:idle?)
        @computers[0] << @last_packet
        @ys << @last_packet.last
      end
    end
    [@ys.first, @ys.last]
  end

  def <<(packet)
    @last_packet = packet
  end

  def has_packet?
    !@last_packet.nil?
  end

  def done?
    @ys.size > 2 && @ys[-2] == @ys[-1]
  end

end

start = Time.now

network = []
50.times{ |i| network << Computer.new(input, i, network) }

computers = network.clone
nat = network[NAT_ADDRESS] = NAT.new(computers, NAT_ADDRESS)

computers.map{ |c| Thread.new{ c.run!(nat) } }
answers = nat.run!

part1 = answers.first
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = answers.last
puts "Part 2: #{part2} (#{Time.now - start}s)"