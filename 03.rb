def get_lines(file_path)
    File.open(file_path, 'r') do |file|
        file.each_line.collect { |line| line.strip }
    end
end

def sum_priorities(lines)
    lines.inject(0) do |acc, line|
        last_index = Array.new(52, -1)

        # priorities (zero-based)
        priorities = line.each_char.collect do |char|
            char.between?('a', 'z') ? char.ord - 'a'.ord : char.ord - 'A'.ord + 26
        end

        in_both, _ = priorities.each_with_index.find do |p, i|
            next true if last_index[p] > -1 && last_index[p] < priorities.length / 2 && i >= priorities.length / 2

            last_index[p] = i
            false
        end

        acc + in_both + 1   # add 1 to priority, to make them 1-based
    end
end

puts sum_priorities(get_lines('inputs/03.txt'))


def sum_badge_priorities(lines)
    lines.each_slice(3).inject(0) do |acc, three_lines|
        first, second, third = three_lines.collect { |line| line.each_char.to_a }

        common = first.select { |item| second.include?(item) }
                            .select { |item| third.include?(item) }

        common = common.first

        priority = (common.between?('a', 'z') ? common.ord - 'a'.ord : common.ord - 'A'.ord + 26) + 1

        acc + priority
    end
end

puts sum_badge_priorities(get_lines('inputs/03.txt'))
