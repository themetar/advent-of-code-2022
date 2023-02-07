def mix_numbers(numbers)
  indexes = (0...numbers.length).to_a   # holds the numbers' actual position, after moving

  reverse_indexes = (0...numbers.length).to_a   # maps actual position to index in the 'numbers' array

  numbers.each_with_index do |n, i|
    index = indexes[i]  # get the numbers 'real' position

    destination = (index + n) % (numbers.length - 1)  # calculate new place

    destination = numbers.length - 1 if destination == 0  # because reasons

    num_position = reverse_indexes[index]   # save the number's id (position in 'numbers')
    # shift reverse indexes
    case index <=> destination
    when -1, 0
      index.upto(destination - 1) { |i| reverse_indexes[i] = reverse_indexes[i+1] }
      from = index
      to = destination
    when 1
      index.downto(destination + 1) { |i| reverse_indexes[i] = reverse_indexes[i-1] }
      from = destination
      to = index
    end
    # place id in destination
    reverse_indexes[destination] = num_position

    # update indexes to reflect new state
    (from..to).each { |i| indexes[reverse_indexes[i]] = i }
  end

  offset = indexes[numbers.index(0)] # position of '0'

  # add 1000th, 2000th and 3000th number
  ([1000, 2000, 3000].collect { |p| numbers[reverse_indexes[(p + offset) % numbers.length]] } .inject(&:+))
end

def ten_mix_numbers(numbers)
  #
  # Same as mix_numbers, but:
  #

  indexes = (0...numbers.length).to_a

  reverse_indexes = (0...numbers.length).to_a

  multiplier = 811589153            # save multiplier
  mod = (numbers.length - 1)        # less typing later
  multiplier_mod = multiplier % mod # you don't need to multiply the big number, destination depends on modulo

  10.times do   # repeat mixing 10 times
    numbers.each_with_index do |n, i|
      index = indexes[i]
      destination = ((index % mod) + (n % mod) * multiplier_mod) % mod  # multiply here to get correct destination

      destination = numbers.length - 1 if destination == 0  # because reasons

      num_position = reverse_indexes[index]
      case index <=> destination
      when -1, 0
        index.upto(destination - 1) { |i| reverse_indexes[i] = reverse_indexes[i+1] }
        from = index
        to = destination
      when 1
        index.downto(destination + 1) { |i| reverse_indexes[i] = reverse_indexes[i-1] }
        from = destination
        to = index
      end
      reverse_indexes[destination] = num_position

      (from..to).each { |i| indexes[reverse_indexes[i]] = i } 
    end
  end

  offset = indexes[numbers.index(0)] # position of '0'

  # add numbers, but apply multiplier
  ([1000, 2000, 3000].collect { |p| numbers[reverse_indexes[(p + offset) % numbers.length]] * multiplier } .inject(&:+))
end
