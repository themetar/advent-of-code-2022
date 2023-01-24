def parse_for(variable, memory)
  stack = [variable]

  until stack.empty?
    variable = stack.pop
    value = memory[variable]
    if Array === value
      operand_a, op, operand_b = value
      if Numeric === memory[operand_a] && Numeric === memory[operand_b]
          memory[variable] = memory[operand_a].send(op, memory[operand_b])
          next
      else
        stack << variable
        stack << operand_a
        stack << operand_b
        next
      end
    end
  end
end

def parse_root(lines)
  # prepare variables
  memory = {}
  lines.each do |line|
    case line
    when /(\w+): (\w+) (.) (\w+)/
      memory[$1] = [$2, $3, $4]
    when /(\w+): (\d+)/
      memory[$1] = $2.to_i    
    else
      puts "Error line read"
    end
  end

  # calculate
  parse_for('root', memory)  

  memory['root']
end

# Gives inverse operation
# e.g. a = b + c => c = a -b
def solve_for(res, op_a, op, op_b, a_b)
  case op
  when '+'
    a_b ? [op_a, res, '-', op_b] : [op_b, res, '-', op_a]
  when '-'
    a_b ? [op_a, res, '+', op_b] : [op_b, op_a, '-', res]
  when '*'
    a_b ? [op_a, res, '/', op_b] : [op_b, res, '/', op_a]
  when '/'
    a_b ? [op_a, res, '*', op_b] : [op_b, op_a, '/', res]
  end
end  

def calc_humn(lines)
  # prep variab;es
  memory = {}
  lines.each do |line|
    case line
    when /(\w+): (\w+) (.) (\w+)/
      memory[$1] = [$2, $3, $4]
    when /(\w+): (\d+)/
      memory[$1] = $2.to_i    
    else
      puts "Error line read"
    end
  end

  # partial parsing

  root_left, _, root_right = memory['root']

  has_humn = {}

  stack = [root_left, root_right]

  until stack.empty?
    variable = stack.pop
    value = memory[variable]
    if variable == 'humn'
      has_humn[variable] = nil  # mark current variable
    elsif Array === value
      operand_a, op, operand_b = value
      if has_humn.include?(operand_a) || has_humn.include?(operand_b)
        has_humn[variable] = nil  # mark current variable
      elsif Numeric === memory[operand_a] && Numeric === memory[operand_b]
          memory[variable] = memory[operand_a].send(op, memory[operand_b])
          next
      else
        stack << variable
        stack << operand_a
        stack << operand_b
        next
      end
    end
  end

  # flip expressions
  flipped_memory = {}

  # set the unknown side of root to equal the other
  if has_humn.include?(root_left)
    flipped_memory[root_left] = memory[root_right]
  else
    flipped_memory[root_right] = memory[root_left]
  end

  # transform expressions
  target_var = 'humn'
  until flipped_memory.include?(target_var)
    memory.each do |variable, value|  # find exp containig target var
      if Array === value
        operand_a, op, operand_b = value
        if operand_a == target_var || operand_b == target_var # found it
          a_b = operand_a == target_var
          inverse = solve_for(variable, operand_a, op, operand_b, a_b)
          flipped_memory[inverse.first] = inverse[1..]  # write expression to get target var
          target_var = variable # former parent is next target
          break
        end
      end
    end
  end

  # copy already calculated numeric values
  flipped_memory.values.flatten.select { |x| !(Numeric === x || ['+', '-', '/', '*'].include?(x)) } .each do |var|
    if Numeric === memory[var]
      flipped_memory[var] = memory[var]
    end
  end

  parse_for('humn', flipped_memory)

  flipped_memory['humn']
end
