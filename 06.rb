def get_lines(file_path)
    File.open(file_path, 'r') do |file|
        file.each_line.collect { |line| line.rstrip }
    end
end

def start_of_data_at(stream, marker_size)
    (stream.length - marker_size).times do |index_of_first|
        return index_of_first + marker_size unless /(.).{0,#{marker_size - 2}}\1/ =~ stream[index_of_first, marker_size]
    end
end

puts start_of_data_at(get_lines('inputs/06.txt').first, 4)

puts start_of_data_at(get_lines('inputs/06.txt').first, 14)
