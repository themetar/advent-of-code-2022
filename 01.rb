def prepare_input
  sums = []
  sum = 0

  File.open("inputs/01.txt", "r") do |inputs|
    inputs.each_line do |line|
      line = line.strip
      if line.empty?
        sums << sum
        sum = 0
      else
        sum += line.to_i
      end
    end
  end

  sums
end

def most_calories
  prepare_input.max
end

def top_three
  prepare_input.sort![-3..].reduce(:+)
end

puts most_calories
puts top_three
