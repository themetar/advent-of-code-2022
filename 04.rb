def section_ids(string)
    string.split(/[-,]/).collect { |str| str.to_i }
end

def count_contained(lines)
    lines.count do |line|
        first_start, first_end, second_start, second_end = section_ids(line)

        first_start.between?(second_start, second_end) && first_end.between?(second_start, second_end) || second_start.between?(first_start, first_end) && second_end.between?(first_start, first_end)
    end
end

def count_overlapped(lines)
    lines.count do |line|
        first_start, first_end, second_start, second_end = section_ids(line)

        first_start.between?(second_start, second_end) || first_end.between?(second_start, second_end) || second_start.between?(first_start, first_end) || second_end.between?(first_start, first_end)
    end
end
