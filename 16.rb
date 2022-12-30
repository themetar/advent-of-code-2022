require './common'

# lines = %{Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
# Valve BB has flow rate=13; tunnels lead to valves CC, AA
# Valve CC has flow rate=2; tunnels lead to valves DD, BB
# Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
# Valve EE has flow rate=3; tunnels lead to valves FF, DD
# Valve FF has flow rate=0; tunnels lead to valves EE, GG
# Valve GG has flow rate=0; tunnels lead to valves FF, HH
# Valve HH has flow rate=22; tunnel leads to valve GG
# Valve II has flow rate=0; tunnels lead to valves AA, JJ
# Valve JJ has flow rate=21; tunnel leads to valve II}.split("\n")

lines = get_lines('inputs/16.txt')

def valves_data(lines)
  lines.collect do |line|
    data = /Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? ((?:[A-Z]+(?:, )?)+)/.match(line)

    name = data[1]
    flow = data[2].to_i
    connected_to = data[3].split(', ')

    {name: name, flow: flow, connected_to: connected_to}
  end
end

valves = valves_data(lines)

puts valves

valve_indices = valves.each_with_index.collect { |v, i| [v[:name], i] }.to_h

puts valve_indices

distance_matrix = Array.new(valves.length) { Array.new(valves.length) }

queue = ['AA']
queue_pointer = 0

until queue_pointer == queue.length
  valve_name = queue[queue_pointer]

  valve_index = valve_indices[valve_name]

  # 0 to self
  distance_matrix[valve_index][valve_index] = 0

  # neighbors
  neighbors = valves[valve_index][:connected_to]
  # add to queue
  neighbors.each { |name| queue << name unless queue.include? name }

  neighbors_indx = neighbors.collect { |name| valve_indices[name] }

  # 1 to neighbors
  neighbors_indx.each do |neighbor_index|
    distance_matrix[valve_index][neighbor_index] = distance_matrix[neighbor_index][valve_index] = 1
  end

  # +1 from neighbors' distance
  neighbors_indx.each do |neighbor_index|
    neighbor_distances = distance_matrix[neighbor_index]

    neighbor_distances.each_with_index do |d, i|
      unless d.nil?
        current = distance_matrix[valve_index][i]

        distance = current.nil? ? d + 1 : d + 1 < current ? d + 1 : current

        distance_matrix[valve_index][i] = distance_matrix[i][valve_index] = distance
      end
    end
  end

  queue_pointer += 1
end

# valve_indices.each do |name, index|
#   # 0 to self
#   distance_matrix[index][index] = 0

#   # 1 to neighbors
#   neighbors = valves[index][:connected_to].collect { |nn| valve_indices[nn] }

#   neighbors.each do |neighbor_i|
#     distance_matrix[index][neighbor_i] = distance_matrix[neighbor_i][index] = 1
#   end

#   # +1 from neighbors' distance
#   neighbors.each do |neighbor_i|
#     neighbor_distances = distance_matrix[neighbor_i]

#     neighbor_distances.each_with_index do |d, i|
#       unless d.nil?
#         current = distance_matrix[index][i]

#         distance = current.nil? ? d + 1 : d + 1 < current ? d + 1 : current

#         distance_matrix[index][i] = distance_matrix[i][index] = distance
#       end
#     end
#   end
# end

print '  |', valve_indices.keys.join('|'), "\n"
print '---' * (valves.length + 1), "\n"
distance_matrix.each_with_index do |row, i|
  print valves[i][:name], '|', row.collect { |d| '%2s' % d } .join('|'), "\n"
  print '---' * (valves.length + 1), "\n"
end

start_valve_id = valve_indices['AA'] # AA
start_valve = valves[start_valve_id] # AA

valves_in_consideration = valves.select { |v| !(v == start_valve || v[:open] || v[:flow] == 0) }

puts valves_in_consideration

# TEST SOMETHING
# valves_in_consideration = ['DD', 'BB', 'JJ', 'HH', 'EE', 'CC'].collect { |name| valves[valve_indices[name]] }
####

puts '-----'

max_path = [start_valve]

total_pressure = proc do |path|
  time = 30
  
  pressure = 0
  
  path.each_cons(2) do |pair|
    v1, v2 = pair

    id_1, id_2 = valve_indices[v1[:name]], valve_indices[v2[:name]]

    # print id_1, ' ', id_2, "\n"

    time_to_open = distance_matrix[id_1][id_2] + 1

    # print time, ' ', time_to_open, "\n"

    if time > time_to_open
      time -= time_to_open
      pressure += time * v2[:flow]
    else
      break
    end
  end

  pressure
end

valves_in_consideration.length.times do

  max_gains = valves_in_consideration.collect do |valve|
 
    insert_points = (1..max_path.length)

    pressures = insert_points.collect do |p|
      seq = max_path.dup.insert(p, valve)
      press = total_pressure.call(seq)
      print seq.collect{|v| v[:name]},' ', press, "\n"

      [total_pressure.call(max_path.dup.insert(p, valve)), p]
    end # [pressure, insert_point]

    # puts '+++'
    # # if valve[:name] == 'HH'
    #   print max_path.collect { |v| v[:name] }, ' ', total_pressure.call(max_path), "\n"
    #   print valve[:name], ' ', pressures, "\n"
    # # end
    # puts '+++'

    best_insert_point = pressures.max { |p1, p2| p1.first <=> p2.first }

    best_insert_point
  end

  max_pressure = max_gains.max { |g1, g2| g1.first <=> g2.first }

  valve_to_choose_id = max_gains.find_index { |pressure, point| pressure == max_pressure.first }

  valve = valves_in_consideration.delete_at(valve_to_choose_id) # delete from consideration

  point = max_pressure[1] # where to insert

  max_path.insert(point, valve)
end

puts 

puts max_path

puts total_pressure.call(max_path)

# puts
# test_path = ['AA', 'DD', 'BB', 'JJ', 'HH', 'EE', 'CC'].collect { |name| valves[valve_indices[name]] }

# puts total_pressure.call(test_path)

# puts

# puts total_pressure.call(['AA', 'DD', 'BB', 'JJ'].collect { |n| valves[valve_indices[n]] })
# puts total_pressure.call(['AA', 'DD', 'JJ', 'BB'].collect { |n| valves[valve_indices[n]] })