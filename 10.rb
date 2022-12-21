def program(lines)
  lines.collect do |line|
    case line
    when 'noop' then [:noop]
    else operation, data = line.split(' '); [operation.to_sym, data.to_i]
    end
  end
end

def register_at_cycles(program, cycles_of_interest)
  op_cycles = {noop: 1, addx: 2}

  counter = 0
  x_register = 1

  cycles = cycles_of_interest.clone

  output = []

  program.each do |instruction|
    operation = instruction.first

    while cycles.first && counter + op_cycles[operation] >= cycles.first  # 'cycles.first &&' guards against empty cycles array, i.e. first being nil
      output << x_register
      cycles.shift
    end

    counter += op_cycles[operation]

    x_register += instruction[1] if operation == :addx

    break if cycles.empty?
  end

  output
end

def signal_strength_at(lines, cycles)
  program = program(lines)

  cycles.zip(register_at_cycles(program, cycles)).inject(0) { |acc, cv_pair| acc + cv_pair.first * cv_pair.last }
end

def render_screen(lines)
  program = program(lines)

  output = register_at_cycles(program, (1..240).to_a)

  output.each_slice(40).collect do |row|
    row.each_with_index.collect { |val, i| i.between?(val-1, val+1) ? '#' : '.' } .join('')
  end .join("\n")
end
