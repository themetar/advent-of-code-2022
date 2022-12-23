def units_sand(lines)
  sand_origin = [500, 0]

  segments = lines.collect do |line|
    seg = []
    line.scan(/(\d+),(\d+)/) { |x, y| seg << [x.to_i, y.to_i] }
    seg
  end

  min_x, min_y, max_x, max_y = [*sand_origin, *sand_origin]

  segments.each do |seg|
    seg.each do |x, y|
      min_x = x if x < min_x
      min_y = y if y < min_y
      max_x = x if x > max_x
      max_y = y if y > max_y
    end
  end

  width = max_x - min_x + 1
  height = max_y - min_y + 1

  image = Array.new(height) { Array.new(width, '.'.to_sym) }

  segments.each do |seg|
    seg.each_cons(2) do |start, finish|
      start_x, start_y = start
      start_x -= min_x
      start_y -= min_y

      finish_x, finish_y = finish
      finish_x -= min_x
      finish_y -= min_y
      
      if start_y == finish_y
        start_x, finish_x = finish_x, start_x if start_x > finish_x # swap if needed

        (finish_x - start_x + 1).times { |i| image[start_y][start_x + i] = '#'.to_sym }
      elsif start_x == finish_x
        start_y, finish_y = finish_y, start_y if start_y > finish_y # swap

        (finish_y - start_y + 1).times { |i| image[start_y + i][start_x] = '#'.to_sym }
      end
    end
  end

  sand_origin = sand_origin.zip([min_x, min_y]).collect { |c, m| c - m }

  image[sand_origin[1]][sand_origin[0]] = :v

  rested_sands = 0

  complete = false

  # 1.times do
  until complete do
    sand_unit = sand_origin.dup

    loop do
      x, y = sand_unit
      
      y_m = y + 1
      
      if y_m == height # fell into the abyss
        complete = true
        break
      end

      if image[y_m][x] == '.'.to_sym  # keep dropping
        sand_unit[1] = y_m
        next
      end

      x_m = x - 1

      if x_m < 0  # fell into abyss
        complete = true
        break
      end

      if image[y_m][x_m] == '.'.to_sym  # keep dropping
        sand_unit[0] = x_m
        sand_unit[1] = y_m
        next
      end

      x_m = x + 1

      if x_m == width  # fell into abyss
        complete = true
        break
      end

      if image[y_m][x_m] == '.'.to_sym  # keep dropping
        sand_unit[0] = x_m
        sand_unit[1] = y_m
        next
      end

      # if the loop came to here, the sand has come to stop
      rested_sands += 1 
      image[y][x] = :o
      break
    end
  end

  rested_sands
end

def units_sand_2(lines)
  sand_origin = [500, 0]

  segments = lines.collect do |line|
    seg = []
    line.scan(/(\d+),(\d+)/) { |x, y| seg << [x.to_i, y.to_i] }
    seg
  end
  
  min_x, min_y, max_x, max_y = [*sand_origin, *sand_origin]

  segments.each do |seg|
    seg.each do |x, y|
      min_x = x if x < min_x
      min_y = y if y < min_y
      max_x = x if x > max_x
      max_y = y if y > max_y
    end
  end

  max_y += 2  # to add floor

  height = max_y - min_y + 1

  floor_length = 2 * height - 1 # 1 + (height - 1) * 2

  floor_start_x = sand_origin[0] - floor_length / 2
  floor_end_x = sand_origin[0] + floor_length / 2

  min_x = floor_start_x if floor_start_x < min_x
  max_x = floor_end_x   if floor_end_x   > max_x

  width = max_x - min_x + 1

  segments << [[floor_start_x, max_y] ,[floor_end_x, max_y]]

  image = Array.new(height) { Array.new(width, '.'.to_sym) }

  segments.each do |seg|
    seg.each_cons(2) do |start, finish|
      start_x, start_y = start
      start_x -= min_x
      start_y -= min_y

      finish_x, finish_y = finish
      finish_x -= min_x
      finish_y -= min_y
      
      if start_y == finish_y
        start_x, finish_x = finish_x, start_x if start_x > finish_x # swap if needed

        (finish_x - start_x + 1).times { |i| image[start_y][start_x + i] = '#'.to_sym }
      elsif start_x == finish_x
        start_y, finish_y = finish_y, start_y if start_y > finish_y # swap

        (finish_y - start_y + 1).times { |i| image[start_y + i][start_x] = '#'.to_sym }
      end
    end
  end

  sand_origin = sand_origin.zip([min_x, min_y]).collect { |c, m| c - m }

  image[sand_origin[1]][sand_origin[0]] = :v

  rested_sands = 0

  complete = false

  loop do
    sand_unit = sand_origin.dup

    loop do
      x, y = sand_unit
      
      y_m = y + 1

      if image[y_m][x] == '.'.to_sym  # keep dropping
        sand_unit[1] = y_m
        next
      end

      x_m = x - 1

      if image[y_m][x_m] == '.'.to_sym  # keep dropping
        sand_unit[0] = x_m
        sand_unit[1] = y_m
        next
      end

      x_m = x + 1

      if image[y_m][x_m] == '.'.to_sym  # keep dropping
        sand_unit[0] = x_m
        sand_unit[1] = y_m
        next
      end

      # if the loop came to here, the sand has come to stop
      rested_sands += 1 
      image[y][x] = :o
      break
    end

    if sand_unit == sand_origin
      # source blocked
      break
    end
  end

  rested_sands
end
