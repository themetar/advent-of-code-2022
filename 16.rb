require './common'

lines = %{Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II}.split("\n")

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

valve_indices.each do |name, index|
  # 0 to self
  distance_matrix[index][index] = 0

  # 1 to neighbors
  neighbors = valves[index][:connected_to].collect { |nn| valve_indices[nn] }

  neighbors.each do |neighbor_i|
    distance_matrix[index][neighbor_i] = distance_matrix[neighbor_i][index] = 1
  end

  # +1 from neighbors' distance
  neighbors.each do |neighbor_i|
    neighbor_distances = distance_matrix[neighbor_i]

    neighbor_distances.each_with_index do |d, i|
      unless d.nil?
        current = distance_matrix[index][i]

        distance = current.nil? ? d + 1 : d + 1 < current ? d + 1 : current

        distance_matrix[index][i] = distance_matrix[i][index] = distance
      end
    end
  end
end

print '  |', valve_indices.keys.join('|'), "\n"
print '---' * (valves.length + 1), "\n"
distance_matrix.each_with_index do |row, i|
  print valves[i][:name], '|', row.collect { |d| '%2d' % d } .join('|'), "\n"
  print '---' * (valves.length + 1), "\n"
end

time = 30

# gain heuristic

current_valve = 0 # AA

puts valves.each_with_index.collect do |valve, index|
  dist = distance_matrix[current_valve][index]
  gain_flow = (time - dist - 1) * valve[:flow]

  others = valve_indices.values.select { |i| i != current && i != index }

  gain_connection = others.collect { |i| (time - dist - 1 - distance_matrix[index][i] - 1) * valves[i][:flow] }

  gain_connection = gain_connection.inject(&:+).to_f / others.length

  [valve[:name], gain_flow + gain_connection]
end.to_a


