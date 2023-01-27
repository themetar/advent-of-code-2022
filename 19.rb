require './common'

lines = get_lines('inputs/19.txt')

blueprints = lines.collect do |line|
  costs = {}
  line.scan(/Each (\w+) robot costs (\d+) (\w+)(?: and (\d+) (\w+))?/) do |robot_type, cost1, material1, cost2, material2|
    # puts _, cost1, material1, cost2, material2
    costs[robot_type.to_sym] = {material1.to_sym => cost1.to_i}
    costs[robot_type.to_sym][material2.to_sym] = cost2.to_i unless cost2.nil?
  end
  costs
end

state = {
  ore_robots:      1,
  clay_robots:     0,
  obsidian_robots: 0,
  geode_robots:    0,
  ore:      0,
  clay:     0,
  obsidian: 0,
  geode:    0,
}

blueprint = blueprints.first

next_states = Proc.new do |state|
  states = [:ore, :clay, :obsidian, :geode].collect do |robot_type|
    if blueprint[robot_type].all? { |material, cost| state[material] >= cost }
      new_state = state.dup
      blueprint[robot_type].each { |material, cost| new_state[material] -= cost }
      new_state[(robot_type.to_s + '_robots').to_sym] += 1
      new_state
    end
  end .select { |s| !s.nil? }
  
  states << state.dup # build nothing
end

test = state.dup
test[:ore] = 10
# puts test
print next_states.call(test), "\n"
