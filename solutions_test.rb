require 'minitest/autorun'

require './common'

# require solution files
('01'..'21').each do |day|
  File.exist?("./#{day}.rb") && require("./#{day}") or next
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

  def test_solution_10_is_correct
    lines = get_lines('inputs/10.txt')

    assert signal_strength_at(lines, [20, 60, 100, 140, 180, 220]) == 14060

    papkfkej = %{###...##..###..#..#.####.#..#.####...##.
#..#.#..#.#..#.#.#..#....#.#..#.......#.
#..#.#..#.#..#.##...###..##...###.....#.
###..####.###..#.#..#....#.#..#.......#.
#....#..#.#....#.#..#....#.#..#....#..#.
#....#..#.#....#..#.#....#..#.####..##..}

    assert render_screen(lines) == papkfkej
  end

  def test_solution_11_is_correct
    lines = get_lines('inputs/11.txt')

    assert monkey_business(lines, 20) == 58794

    assert monkey_business_2(lines, 10000) == 20151213744
  end

  def test_solution_12_is_correct
    lines = get_lines('inputs/12.txt')

    assert fewest_steps(lines) == 528

    assert fewest_steps_2(lines) == 522
  end

  def test_solution_13_is_correct
    lines = get_lines('inputs/13.txt')

    assert sum_of_pairs_indices(lines) == 5588
    assert decoder_key(lines) == 23958
  end

  def test_solution_14_is_correct
    lines = get_lines('inputs/14.txt')

    assert units_sand(lines) == 793

    assert units_sand_2(lines) == 24166
  end

  def test_solution_15_is_correct
    skip  # because it takes a long time

    lines = get_lines('inputs/15.txt')

    sensors = parse_sensors_data(lines)

    query_y = 2000000
    
    assert positions_cant_contain_beacon(sensors, query_y) == 6275922

    assert tuning_frequency(sensors) == 11747175442119

  end

  def test_solution_17_is_correct
    line = get_lines('inputs/17.txt').first

    assert simulate_rocks(line, 2022) == 3193

    assert simulate_rocks(line, 1000000000000) == 1577650429835
  end
  
  def test_solution_18_is_correct
    lines = get_lines('inputs/18.txt')

    voxels = lines.collect { |line| line.split(',').collect(&:to_i) }

    assert count_nontouching_faces(voxels) == 4320

    assert count_exterior_faces(voxels) == 2456
  end

  def test_solution_20_is_correct
    numbers = get_lines('inputs/20.txt').collect(&:to_i)

    assert mix_numbers(numbers) == 27726

    assert ten_mix_numbers(numbers) == 4275451658004
  end

  def test_solution_21_is_correct
    lines = get_lines('inputs/21.txt')
    
    assert parse_root(lines) == 232974643455000

    assert calc_humn(lines) == 3740214169961
  end
end
