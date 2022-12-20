def trees(lines)
  lines.collect { |line| line.split(''). collect { |digit| digit.to_i }}
end

def visible_trees_count(lines)
  def skyline(field, outer_loop, inner_loop, transposed)
    max_heights = Array.new(field.length) { Array.new(field.first.length, 0) }

    outer_loop.each do |out|
      max = -1    # edge is open!
      inner_loop.each do |inn|
        max_heights[transposed ? inn : out][transposed ? out : inn] = max
        max = field[transposed ? inn : out][transposed ? out : inn] if field[transposed ? inn : out][transposed ? out : inn] > max
      end
    end

    max_heights
  end

  field = trees(lines)

  nrows = field.length
  ncols = field.first.length

  west_skyline = skyline(field, 0.upto(nrows - 1), 0.upto(ncols - 1), false)      # west; from left
  east_skyline = skyline(field, 0.upto(nrows - 1), (ncols - 1).downto(0), false)  # east; from right
  north_skyline = skyline(field, 0.upto(ncols - 1), 0.upto(nrows - 1), true)      # north; from up
  south_skyline = skyline(field, 0.upto(ncols - 1), (nrows - 1).downto(0), true)  # south; from up

  0.upto(nrows - 1).inject(0) do |acc, row|
    acc + 0.upto(ncols - 1).count do |col|
      [west_skyline, east_skyline, north_skyline, south_skyline].any? { |sl| sl[row][col] < field[row][col] }
    end
  end
end

def highest_scenic_score(lines)
  def viewing_distance(field, outer_loop, inner_loop, transposed)
    distances = Array.new(field.length) { Array.new(field.first.length, 0) }

    outer_loop.each do |out|
      view_potential = [0] * 10

      inner_loop.each do |inn|
        row = transposed ? inn : out
        col = transposed ? out : inn
        tree_height = field[row][col]
        distances[row][col] = view_potential[tree_height]

        view_potential.length.times { |h| view_potential[h] = h <= tree_height ? 1 : view_potential[h] + 1 }
      end
    end

    distances
  end

  field = trees(lines)

  nrows = field.length
  ncols = field.first.length

  west_vd = viewing_distance(field, 0.upto(nrows - 1), 0.upto(ncols - 1), false)      # west; from left
  east_vd = viewing_distance(field, 0.upto(nrows - 1), (ncols - 1).downto(0), false)  # east; from right
  north_vd = viewing_distance(field, 0.upto(ncols - 1), 0.upto(nrows - 1), true)      # north; from up
  south_vd = viewing_distance(field, 0.upto(ncols - 1), (nrows - 1).downto(0), true)  # south; from up

  0.upto(nrows - 1).inject(0) do |acc, row|
    top_ss_for_row = 0.upto(ncols - 1).inject(0) do |acc, col|
      scenic_score = [west_vd, east_vd, north_vd, south_vd].inject(1) { |acc, vd| acc * vd[row][col] }
      acc > scenic_score ? acc : scenic_score
    end
    acc > top_ss_for_row ? acc : top_ss_for_row
  end
end
