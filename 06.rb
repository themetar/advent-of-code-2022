def start_of_data_at(stream, marker_size)
    (stream.length - marker_size).times do |index_of_first|
        return index_of_first + marker_size unless /(.).{0,#{marker_size - 2}}\1/ =~ stream[index_of_first, marker_size]
    end
end
