require './common'

# Actually simulate tail's travel. It looks tractable enough

def rope_motions(lines)
  lines.collect do |line|
    direction, steps = /(\w) (\d+)/.match(line)[1, 2]
    direction = direction.to_sym
    steps = steps.to_i
    [direction, steps]
  end
end

def rope_field(motions)
  extreme_coords = [0, 0, 0, 0] # min x, y; max x, y
  head_position = [0, 0]
  motions.each do |direction, steps|
    case direction
    when :L then index = 0; op = :- #head_position[0] -= steps
    when :R then index = 0; op = :+ #head_position[0] += steps
    when :U then index = 1; op = :- #head_position[1] -= steps
    when :D then index = 1; op = :+ #head_position[1] += steps    
    end

    head_position[index] = head_position[index].send(op, steps)

    extreme_coords[0] = head_position[0] if head_position[0] < extreme_coords[0]
    extreme_coords[1] = head_position[1] if head_position[1] < extreme_coords[1]
    extreme_coords[2] = head_position[0] if head_position[0] > extreme_coords[2]
    extreme_coords[3] = head_position[1] if head_position[1] > extreme_coords[3]
  end

  field = Array.new(extreme_coords[1].abs + 1 + extreme_coords[3]) { Array.new(extreme_coords[0].abs + 1 + extreme_coords[2]) }

  # field, and starting postition (ofset cord origin)
  [field, [extreme_coords[0].abs, extreme_coords[1].abs]]
end

def visited_positions(lines)
  motions = rope_motions(lines)

  field, start = rope_field(motions)

  head_position = start.clone
  tail_position = start.clone

  field[tail_position[1]][tail_position[0]] = :T

  motions.each do |direction, steps|
    case direction
    when :L then index = 0; op = :- #head_position[0] -= steps
    when :R then index = 0; op = :+ #head_position[0] += steps
    when :U then index = 1; op = :- #head_position[1] -= steps
    when :D then index = 1; op = :+ #head_position[1] += steps    
    end

    steps.times do
      old_x, old_y = head_position

      head_position[index] = head_position[index].send(op, 1)
      
      unless (head_position[0] - tail_position[0]).abs < 2 && (head_position[1] - tail_position[1]).abs < 2 # touching 
        tail_position[0] = old_x
        tail_position[1] = old_y

        field[old_y][old_x] = :T
      end
    end
  end

  field.inject(0) { |acc, row| acc + row.count { |cell| cell == :T} }
end

def visited_positions_rope(lines)
  def touching?(x_a, y_a, x_b, y_b)
    (x_a - x_b).abs < 2 && (y_a - y_b).abs < 2
  end

  motions = rope_motions(lines)

  # motions.each { |m| print m, "\n"} # !!!!!!!!!!!!!!!!

  field, start = rope_field(motions)

  rope = Array.new(10) { start.clone }

  field[rope.last[1]][rope.last[0]] = :T

  motions.each do |direction, steps|
    case direction
    when :L then coord = 0; op = :- # head x -= steps
    when :R then coord = 0; op = :+ # head x += steps
    when :U then coord = 1; op = :- # head y -= steps
    when :D then coord = 1; op = :+ # head y += steps    
    end

    steps.times do
      rope.each_with_index do |knot, i|
        if i == 0 # head
          knot[coord] = knot[coord].send(op, 1)
        else  # tail(s)
          lead = rope[i - 1]

          unless touching?(*lead, *knot)
            # follow your leader
            knot[0] = knot[0] + (lead[0] > knot[0] ? 1 : lead[0] == knot[0] ? 0 : -1)
            knot[1] = knot[1] + (lead[1] > knot[1] ? 1 : lead[1] == knot[1] ? 0 : -1)
          end

          if i == rope.length - 1 # rope's tail
            tail_x, tail_y = knot
            field[tail_y][tail_x] = :T
          end
        end
      end
    end
  end

  # rope.each { |m| print m, "\n"} # !!!!!!!!!!!!!!!!
  # field.each { |m| print m, "\n"} # !!!!!!!!!!!!!!!!

  field.inject(0) { |acc, row| acc + row.count { |cell| cell == :T} }
end

input_2_1 = %{R 5
  U 8
  L 8
  D 3
  R 17
  D 10
  L 25
  U 20}

# puts visited_positions_rope(input_2_1.lines.collect(&:strip))