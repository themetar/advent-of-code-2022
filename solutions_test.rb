require 'minitest/autorun'

require './common'

# require solution files
('01'..'07').each do |day|
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

  def test_solution_04_is_correct
    lines = get_lines('inputs/04.txt')

    assert count_contained(lines) == 483

    assert count_overlapped(lines) == 874
  end

  def test_solution_05_is_correct
    lines = get_lines('inputs/05.txt')

    assert top_of_stacks(lines) == 'VRWBSFZWM'
    assert top_of_stacks_2(lines) == 'RBTWJWMCF'
  end

  def test_solution_06_is_correct
    lines = get_lines('inputs/06.txt')

    assert start_of_data_at(lines.first, 4) == 1757

    assert start_of_data_at(lines.first, 14) == 2950    
  end

  def test_solution_07_is_correct
    lines = get_lines('inputs/07.txt')

    assert sum_of_sizes(lines) == 1350966
    
    assert dir_to_del_size(lines) == 6296435
  end

end