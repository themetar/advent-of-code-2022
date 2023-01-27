require './common'

lines = get_lines('inputs/19.txt')

blueprints = lines.collect do |line|
  costs = {}
  line.scan(/Each (\w+) robot costs (\d+) (\w+)(?: and (\d+) (\w+))?/) do |robot_type, cost1, material1, cost2, material2|
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

# test = state.dup
# test[:ore] = 10
# # puts test
# print next_states.call(test), "\n"

stackesque = [[state]]

max_obsidian = 0

loop do
  break if stackesque.empty?

  if stackesque.last.length == 0
    stackesque.pop
    next
  end

  # !!!!
  if stackesque.length == 6
    stackesque.each do |level|
      print level, "\n" #, 'quoi?', "\n"
    end
    break
  end
  # !!!

  state = stackesque.last.pop

  if stackesque.length == 18 # 24 + 1
    max_obsidian = state[:obsidian] if state[:obsidian] > max_obsidian    
    next
  end

  # build robot
  build_states = next_states.call(state)
  # increment resources
  build_states.each do |st|
    [:ore, :clay, :obsidian, :geode].each do |material|
      st[material] += st[(material.to_s + '_robots').to_sym]
    end
  end

  stackesque << build_states
end

puts max_obsidian

