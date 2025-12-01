def time(str = nil, output = true, &block)
  start = Time.now
  ret = block.call
  dur = Time.now - start
  out = (str.nil? ? "" : "#{str}: ") + (output ? "#{ret} (#{dur}s)" : "#{dur}s")
  puts out
  ret
end