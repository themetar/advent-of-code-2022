require 'json'

def compare(a, b)
  comp = a <=> b
  return comp if comp # not nil

  case a
  when Integer then compare([a], b)
  when Array
    case b
    when Integer then compare(a, [b])
    when Array
      return -1 if  a.length.zero? && !b.length.zero?
      return  0 if  a.length.zero? &&  b.length.zero?
      return  1 if !a.length.zero? &&  b.length.zero?
      comp = compare(a.first, b.first)
      return comp unless comp == 0
      compare(a[1..], b[1..])
    end
  end
end

def sum_of_pairs_indices(lines)
  packets = lines.select { |l| !l.empty? }
  packets = packets.collect { |p| JSON.parse(p)}

  sum = 0

  packets.each_slice(2).with_index do |slice, i|
    p1, p2 = slice
    sum += (i + 1) if compare(p1, p2) < 1 # p1 < p2 or p1 == p2
  end

  sum
end

def decoder_key(lines)
  packets = lines.select { |l| !l.empty? }
  packets = packets.collect { |p| JSON.parse(p)}

  packets << [[2]] << [[6]]

  sorted = packets.sort { |a, b| compare(a, b) }

  index_k1 = sorted.index { |p| compare(p, [[2]]) == 0 }
  index_k2 = sorted.index { |p| compare(p, [[6]]) == 0 }

  sum = 0

  (index_k1 + 1) * (index_k2 + 1)
end
