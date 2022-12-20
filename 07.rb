def dir_sizes(lines)
  sizes = []
  path_indices = []
  dir_count = 0

  lines.each do |line|
    case line
    when /\$ cd \.\./
      path_indices.pop
    when /\$ cd .+/
      path_indices << dir_count
      sizes << 0  # add counter (inited to 0) for new directory
      dir_count += 1
    when /\d+ .+/
      size = /(\d+) .+/.match(line)[1].to_i
      path_indices.each { |dir_id| sizes[dir_id] += size }  # add to the size of each directory in path
    end
  end

  sizes
end

def sum_of_sizes(lines)
  sizes = dir_sizes(lines)

  sizes.select { |val| val <= 100000 } .inject(&:+)
end

def dir_to_del_size(lines)
  sizes = dir_sizes(lines)

  needed_to_free = 30000000 - (70000000 - sizes[0]) # needed_space - available_space ; available_space = total_space - used_space
  sizes.select { |size| size >= needed_to_free }.min
end
