require 'minitest/autorun'

require './common'

# require solution files
('01'..'09').each do |day|
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

  def test_solution_08_is_correct
    lines = get_lines('inputs/08.txt')

    assert visible_trees_count(lines) == 1794

    assert highest_scenic_score(lines) == 199272
  end

  def test_solution_09_is_correct
    lines = get_lines('inputs/09.txt')

    assert visited_positions(lines) == 6745

    input_2_0 = %{R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2}

    assert visited_positions_rope(input_2_0.lines.collect(&:strip)) == 1

      input_2_1 = %{R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20}

    assert visited_positions_rope(input_2_1.lines.collect(&:strip)) == 36

    assert visited_positions_rope(lines) == 2793
  end
end
