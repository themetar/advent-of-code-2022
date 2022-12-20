require 'minitest/autorun'

require './common'

# require solution files
('01'..'03').each do |day|
  File.exist?("./#{day}.rb") && require("./#{day}") or break
end

class SolutionsTest < Minitest::Test
  def test_solution_01_is_correct
    lines = get_lines('inputs/01.txt')
    
    assert most_calories(lines) == 67450

    assert top_three(lines) == 199357
  end

  def test_solution_02_is_correct
    lines = get_lines('inputs/02.txt')

    assert total_score(lines, SCORE_OUTCOMES) == 13009

    assert total_score(lines, SCORE_OUTCOMES_CORRECTED) == 10398  
  end

  def test_solution_03_is_correct
    lines = get_lines('inputs/03.txt')

    assert sum_priorities(lines) == 7795
    assert sum_badge_priorities(lines) == 2703
  end
end