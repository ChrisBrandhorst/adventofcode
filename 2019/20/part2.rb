



def portal_paths(maze)
  portal_paths = {}

  maze.portals.map(&:entry).each do |p|
    maze.portals.map(&:entry).each do |p2|
      next if p == p2

      if portal_paths[p2] && !portal_paths[p2][p].nil?
        portal_paths[p] ||= {}
        portal_paths[p][p2] = portal_paths[p2][p].reverse
        next
      end

      path = maze.path_to(p, p2)
      if path
        portal_paths[p] ||= {}
        portal_paths[p][p2] = path
      end
    end
  end

  portal_paths
end

@cache = {}
@entered = []
def distance_to_portal(maze, current, target, portal_paths, total_path = [], l = 0)
  return 0 if current == target

  # cacheKey = current.portal.code + current.portal.dir.to_s# + l.to_s
  # if @cache.has_key?(cacheKey)
  #   return @cache[cacheKey]
  # end

  res = Float::INFINITY

  # return res if total_path.size > 100

  paths = portal_paths[current] || {}

  puts "#{" "*l}Current: #{current.portal.code} @ #{l}"

  paths.each do |t,p|

    if t == target
      if l == 0
        return p.size
      else
        next
      end
    elsif t.portal.is_start?
      next
    elsif l == 0 && t.portal.outer?
      next
    elsif @entered.include?( t.portal.code + t.portal.dir.to_s + l.to_s )
      next
    else
      @entered << t.portal.code + t.portal.dir.to_s + l.to_s
      puts "#{" "*l}Entering: #{t.portal.code} @ #{l} (#{t.portal.dir})"
      new_l = l + (t.portal.outer? ? -1 : 1)
      d = p.size + distance_to_portal(
        maze,
        t.portal.other_side.entry,
        target,
        portal_paths,
        total_path + [t.portal],
        new_l
      )
    end

    res = [res, d].min
  end

  # @cache[cacheKey] = res
  res
end



start = Time.now
portal_paths = portal_paths(maze)

part2 = distance_to_portal(
  maze,
  maze.portals.detect(&:is_start?).entry,
  maze.portals.detect(&:is_finish?).entry,
  portal_paths
)
puts "Part 2: #{part2} (#{Time.now - start}s)"