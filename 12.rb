def fewest_steps(lines)
  def array_set(arry, row, col, value)
    arry[row][col] = value
  end

  topology = lines.collect { |l| l.split('') }

  neighbors = proc do |row, col|
    [[0, 1], [1, 0], [0, -1], [-1, 0]].collect { |r, c| [row + r, col + c] } .select { |r, c| !(r < 0 || c < 0 || r == topology.length || c == topology.first.length) }
  end

  valid_moves = proc do |row, col|
    height = topology.dig(row, col)
    neighbors.call(row, col).select { |square| topology.dig(*square).ord <= height.ord + 1 }
  end

  visited_squares = Array.new(topology.length) { Array.new(topology.first.length, -1) }

  queue = []

  start = topology.length.times.inject(nil) { |_, row| col = topology[row].find_index('S'); break [row, col] if col }
  finish = topology.length.times.inject(nil) { |_, row| col = topology[row].find_index('E'); break [row, col] if col }

  array_set(topology, *start, 'a')  # set proper heights
  array_set(topology, *finish, 'z') # set proper heights
  
  square = start
  array_set(visited_squares, *start, 0)

  loop do
    step = visited_squares.dig(*square)

    possible_moves = valid_moves.call(*square)
    
    possible_moves.each do |move|
      if visited_squares.dig(*move) == -1
        # not yet visited
        array_set(visited_squares, *move, step + 1)
        queue << move
      end

      if move == finish
        return visited_squares.dig(*move) # return step count
      end
    end

    square = queue.shift
  end
end

def fewest_steps_2(lines)
  def array_set(arry, row, col, value)
    arry[row][col] = value
  end

  topology = lines.collect { |l| l.split('') }

  rcount = topology.length
  ccount = topology.first.length

  neighbors = proc do |row, col|
    [[0, 1], [1, 0], [0, -1], [-1, 0]].collect { |r, c| [row + r, col + c] } .select { |r, c| !(r < 0 || c < 0 || r == rcount || c == ccount) }
  end

  valid_moves = proc do |row, col|
    height = topology.dig(row, col)
    neighbors.call(row, col).select { |square| topology.dig(*square).ord >= height.ord - 1 }  # reverse traversal rules: go down just one (reverse clib up), or jump many (reverse jump down)
  end

  visited_squares = Array.new(rcount) { Array.new(ccount, -1) }

  start = rcount.times.inject(nil) { |_, row| col = topology[row].find_index('S'); break [row, col] if col }
  finish = rcount.times.inject(nil) { |_, row| col = topology[row].find_index('E'); break [row, col] if col }

  array_set(topology, *start, 'a')  # set proper heights
  array_set(topology, *finish, 'z') # set proper heights

  queue = [finish] # start from E
  array_set(visited_squares, *finish, 0)

  while square = queue.shift do # until #shift rerurns nil
    next if topology.dig(*square) == 'a'  # reached an 'a', any next step will have longer path length, we can stop early

    step = visited_squares.dig(*square)

    possible_moves = valid_moves.call(*square)
    
    possible_moves.each do |move|
      if visited_squares.dig(*move) == -1
        # not yet visited
        array_set(visited_squares, *move, step + 1)
        queue << move
      end
    end
  end

  lowest_squares = rcount.times.inject([]) { |acc, r| acc + ([r].product ccount.times.select { |c| topology[r][c] == 'a' && visited_squares[r][c] > -1 }) }
  path_lengths = lowest_squares.collect { |sq| visited_squares.dig(*sq) }

  path_lengths.min  # shortest
end
