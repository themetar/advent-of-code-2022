def sum_by_elf
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
  sum_by_elf.max
end

def top_three
  sum_by_elf.sort![-3..].reduce(:+)
end
