def simulate_rocks(jets_string, total_rocks)
  rocks = [
    [0b0011110],  # ..####.

    [0b0001000,   # ...#...
     0b0011100,   # ..###..
     0b0001000],  # ...#...

    [0b0011100,   # ..###..   // vertically flipped
     0b0000100,   # ....#..
     0b0000100],  # ....#..
    
    [0b0010000,   # ..#....
     0b0010000,   # ..#....
     0b0010000,   # ..#....
     0b0010000],  # ..#....

    [0b0011000,   # ..##...
     0b0011000]   # ..##...
  ]

  left_edge   =  0b1000000
  right_edge  =  0b0000001

  edges = {'<' => left_edge, '>' => right_edge}

  actions = {'<' => :<<, '>' => :>>}
  undos   = {'<' => :>>, '>' => :<<}

  cave = []

  total_cave_height = 0

  local_cave_height = 0

  rock_count = 0

  jet_index = 0

  history = {}  # key is [rock id, jet id, cave top], value is [cave height, rock count] 

  while rock_count < total_rocks
    rock_id = rock_count % rocks.length
    rock = rocks[rock_id].dup

    rock_count += 1

    # calc cave top
    cave_top = []
    sift = 0b0000000
    (cave.length-1).downto(0) do |i|
      next if cave[i] == 0
      cave_top.unshift(cave[i])
      sift |= cave[i]
      break if sift == 0b1111111
    end

    # calc local cave height
    local_cave_height += cave[local_cave_height...].count { |c| c != 0 }

    # jump ahead if it's possible
    if history.has_key?([rock_id, jet_index, cave_top])
      prev_height, prev_count = history[[rock_id, jet_index, cave_top]]

      rock_period = rock_count - prev_count

      delta_height = local_cave_height - prev_height

      remaining = total_rocks - rock_count

      times = remaining / rock_period

      total_cave_height += local_cave_height + times * delta_height - cave_top.length

      rock_count += times * rock_period

      # reset
      cave = cave_top
      local_cave_height = cave.length
      history = {}
    end

    # put current state in history
    history[[rock_id, jet_index, cave_top]] = [local_cave_height, rock_count]

    #
    # simulate dropping rock
    #
    empty_rows = (cave.length-1).downto(0).inject(0) { |count, i| break count if cave[i] != 0; count + 1 }

    rock_position = cave.length - empty_rows + 3

    cave.concat [0] * (3 - empty_rows) if empty_rows < 3

    cave.concat [0] * (rock.length - (cave.length - rock_position)) if rock.length > (cave.length - rock_position)

    loop do
      jet = jets_string[jet_index]  # get jet
      jet_index = (jet_index + 1) % jets_string.length  # advance jet 'playhead'
      #
      # do jet
      edge_check = rock.all? { |r| r & edges[jet] == 0 }
      if edge_check
        rock.collect! { |r| r.send(actions[jet], 1) }
        cave_check = rock.each_with_index.all? { |r, i| r & cave[rock_position + i] == 0 }
        unless cave_check
          rock.collect! { |r| r.send(undos[jet], 1) } # undo if rock hits any rock formations in cave
        end
      end
      #
      # do fall
      rock_position -= 1
      cave_check = rock.each_with_index.all? { |r, i| r & cave[rock_position + i] == 0 }
        if rock_position < 0 || !cave_check # hits bottom or some rock
        rock_position += 1  # undo drop
        rock.length.times do |i|
          cave[rock_position + i] |= rock[i]  # bake rock in cave
        end
        break # go to next rock
      end
    end
  end

  total_cave_height + cave.count { |r| r != 0 }
end
