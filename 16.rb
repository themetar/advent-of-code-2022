# exaust via time

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

##
# Returns distance matrix between valves and 
def parse_valves_data(lines)
  lines.collect do |line|
    data = /Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? ((?:[A-Z]+(?:, )?)+)/.match(line)

    name = data[1]
    flow = data[2].to_i
    connected_to = data[3].split(', ')

    {name: name, flow: flow, connected_to: connected_to}
  end
end
  
valves = parse_valves_data(lines)

valve_indices = valves.each_with_index.collect { |v, i| [v[:name], i] }.to_h

connections = valves.collect { |valve| valve[:connected_to].collect { |valve_name| valve_indices[valve_name] } }

##
# Returns a distance matrix between nodes
#
def get_distance_matrix(connections)

  distance_matrix = Array.new(connections.length) { Array.new(connections.length) }

  queue = [0]
  queue_pointer = 0

  until queue_pointer == queue.length
    valve_index = queue[queue_pointer]

    # 0 to self
    distance_matrix[valve_index][valve_index] = 0

    # neighbors
    neighbors = connections[valve_index]
    # add to queue
    neighbors.each { |neighbor_index| queue << neighbor_index unless queue.include? neighbor_index }

    # 1 to neighbors
    neighbors.each do |neighbor_index|
      distance_matrix[valve_index][neighbor_index] = distance_matrix[neighbor_index][valve_index] = 1
    end

    # +1 from neighbors' distance
    neighbors.each do |neighbor_index|
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

  distance_matrix
end

distance_matrix = get_distance_matrix(connections)


total_pressure = proc do |sequence, time|
  pressure = 0

  sequence.each_cons(2) do |pair|
      id_1, id_2 = pair

      time_to_open = distance_matrix[id_1][id_2] + 1

      if time > time_to_open
        time -= time_to_open
        pressure += time * valves[id_2][:flow]
      else
        break
      end
  end

  pressure
end

time_to_open_all = proc do |sequence|
  sequence.each_cons(2).inject(0) do |acc, pair|
    id_1, id_2 = pair

    time_to_open = distance_matrix[id_1][id_2] + 1

    acc + time_to_open
  end
end

start_valve_id = valve_indices['AA'] # AA
start_valve = valves[start_valve_id] # AA

valves_in_consideration = valves.select { |v| !(v == start_valve || v[:flow] == 0) } .collect { |v| valve_indices[v[:name]] }

stack_of_queues = [valves_in_consideration.dup]

sequence = [start_valve_id]

max = 0

counter = 0

until stack_of_queues.empty?
  # puts stack_of_queues.collect { |q| q.collect { |v| v[:name] } .join(' ') } .join("\n")
  # puts

  queue = stack_of_queues[-1] # top of stack

  until queue.empty?
    sequence << queue.shift

    # puts "seq: " + sequence.collect { |v| v[:name] } .join(' ')

    if time_to_open_all.call(sequence) < 30
      
      pressure = total_pressure.call(sequence, 30)

      counter += 1

      max = pressure if pressure > max
      
      next_queue = valves_in_consideration.dup
      sequence.each do |v|
        next_queue.delete(v)
      end

      stack_of_queues << next_queue

      queue = stack_of_queues[-1] # update top of stack

      next
    else
      sequence.pop

      next  # next in queue
    end
  end

  sequence.pop
  stack_of_queues.pop
end

puts max

puts counter