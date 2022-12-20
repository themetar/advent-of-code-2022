def get_lines(file_path)
  File.open(file_path, 'r') do |file|
      file.each_line.collect { |line| line.rstrip }
  end
end
