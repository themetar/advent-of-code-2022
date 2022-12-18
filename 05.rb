def get_lines(file_path)
    File.open(file_path, 'r') do |file|
        file.each_line.collect { |line| line.rstrip }
    end
end

lines = get_lines('inputs/05.txt')

def split_input(lines)
    break_index = lines.find_index('') # empty line between crates and instructions

    stacks = lines[0...break_index]

    stacks = stacks.collect do |line|
        arr = []
        line.scan(/.(.).\s?/) { |match| arr << match[0] }
        arr
    end

    stacks = stacks[0..-2].transpose.collect { |s| s.reverse!.select { |c| c != " " } }

    instructions = lines[(break_index + 1)..-1]

    [stacks, instructions]
end

def top_of_stacks(lines)
    stacks, instructions = split_input(lines)

    instructions.each do |instruction|
        ammount, from, to = /move (\d+) from (\d) to (\d)/.match(instruction)[1..-1].collect { |dd| dd.to_i }

        from, to = from - 1, to - 1

        stacks[to].concat(stacks[from].slice!(-ammount..-1).reverse!)
    end

    stacks.collect { |stack| stack.last || '' }.join('')
end

puts top_of_stacks(lines)

def top_of_stacks_2(lines)
    stacks, instructions = split_input(lines)

    instructions.each do |instruction|
        ammount, from, to = /move (\d+) from (\d) to (\d)/.match(instruction)[1..-1].collect { |dd| dd.to_i }

        from, to = from - 1, to - 1

        stacks[to].concat(stacks[from].slice!(-ammount..-1))    # don't reverse
    end

    stacks.collect { |stack| stack.last || '' }.join('')
end

puts top_of_stacks_2(lines)
