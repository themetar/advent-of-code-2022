def sum_by_elf(lines)
  sums = []
  sum = 0

  lines.each do |line|
    if line.empty?
      sums << sum
      sum = 0
    else
      sum += line.to_i
    end
  end

  sums
end

def most_calories(lines)
  sum_by_elf(lines).max
end

def top_three(lines)
  sum_by_elf(lines).sort![-3..].reduce(:+)
end
