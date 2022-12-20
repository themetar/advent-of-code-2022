require 'minitest/autorun'

require './01.rb'

class SolutionsTest < Minitest::Test
  def test_solution_01_is_correct
    assert most_calories == 67450

    assert top_three == 199357
  end
end