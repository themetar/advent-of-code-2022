SCORE_OUTCOMES = {
  "B X" => 1,
  "C Y" => 2,
  "A Z" => 3,
  "A X" => 4,
  "B Y" => 5,
  "C Z" => 6,
  "C X" => 7,
  "A Y" => 8,
  "B Z" => 9,
}

SCORE_OUTCOMES_CORRECTED = {
  "B X" => 1,
  "C X" => 2,
  "A X" => 3,
  "A Y" => 4,
  "B Y" => 5,
  "C Y" => 6,
  "C Z" => 7,
  "A Z" => 8,
  "B Z" => 9,
}

def total_score(strategy)
  File.open("inputs/02.txt", "r") do |inputs|
    inputs.each_line.reduce(0) { |acc, line| acc + strategy[line.strip] }
  end
end

puts total_score(SCORE_OUTCOMES)

puts total_score(SCORE_OUTCOMES_CORRECTED)
