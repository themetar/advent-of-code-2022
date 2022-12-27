def parse_sensors_data(lines)
  lines.collect do |line|
    data = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.match(line)[1..]
    data = data.collect { |d| d.to_i }

    sens_x, sens_y = data[0..1]
    beacon_x, beacon_y = data[2..]

    manhattan_r = (beacon_x - sens_x).abs + (beacon_y - sens_y).abs

    {position: [sens_x, sens_y] , beacon: [beacon_x, beacon_y], manhattan_r: manhattan_r}
  end
end

def covered_ranges_at_y(sensors, query_y)
  ranges = sensors.collect do |sens|
    sens_x, sens_y = sens[:position]
    y_d = (sens_y - query_y).abs
    if y_d > sens[:manhattan_r]
      []
    else
      x_d = sens[:manhattan_r] - y_d
      [sens_x - x_d, sens_x + x_d]
    end
  end .select { |r| !r.empty? }

  ranges = ranges.sort { |r1, r2| r1.first <=> r2.first }

  # combine overlapping

  loop do
    len = ranges.length

    ranges = ranges[1..].inject([ranges.first]) do |acc, range|
      r1_s, r1_e = acc[-1]
      r2_s, r2_e = range
      
      if r1_s.between?(r2_s, r2_e) || r1_e.between?(r2_s, r2_e) || r2_s.between?(r1_s, r1_e) || r2_e.between?(r1_s, r1_e) # fourth puzzle - yay!
        new_range = [r1_s < r2_s ? r1_s : r2_s, r1_e > r2_e ? r1_e : r2_e]
        next acc[0..-2] + [new_range]
      end

      acc + [range]
    end

    break if len == ranges.length # no merge has happened
  end

  ranges
end

def positions_cant_contain_beacon(sensors, query_y)
  ranges = covered_ranges_at_y(sensors, query_y)

  beacons = sensors.collect { |sens| sens[:beacon] }.uniq

  ranges.inject(0) { |acc, rang| acc + (rang[1] - rang[0] + 1) } - beacons.count { |_, y| y == query_y }
end

def tuning_frequency(sensors)
  beacon_x = 0
  beacon_y = 0

  4000001.times do |i|
    ranges = covered_ranges_at_y(sensors, i)

    if ranges.length > 1
      beacon_x = ranges.first[1] + 1  # the empty space between the two ranges
      beacon_y = i                    # the queried row
      break
    end
  end

  beacon_x * 4000000 + beacon_y
end
