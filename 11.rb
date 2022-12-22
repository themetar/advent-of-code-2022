def monkeys(lines)
  struct_Monkey = Struct.new(:items, :operation, :divisor, :next_monkeys, :counter)

  monkeys = []

  lines.each_slice(7) do |monkey_data|
    # skip first line
    match =  /items: ((?:\d+(?:,\s)?)+)/.match(monkey_data[1])
    items = match[1].split(', ').collect { |dd| dd.to_i }  # item list

    match = /old (.) (.+)/.match(monkey_data[2])
    operation = {op: match[1], value: match[2]}  # [operation, value]

    match = /divisible by (\d+)/.match(monkey_data[3])
    divisor = match[1].to_i

    next_monkeys = {}
    monkey_data[4,2].each do |condition|
      match = /(true|false): throw to monkey (\d+)/.match(condition)
      next_monkeys[match[1] == 'true'] = match[2].to_i
    end

    monkeys << struct_Monkey.new(items, operation, divisor, next_monkeys, 0)
  end

  monkeys
end

def monkey_business(lines, rounds)
  monkeys = monkeys(lines)

  rounds.times do
    monkeys.each do |monkey|
      monkey.items.each do |item|
        item = item.send(monkey.operation[:op], monkey.operation[:value] == "old" ? item : monkey.operation[:value].to_i) # monkey inspects
        item /= 3 # integer division
        test = item % monkey.divisor == 0 # divisible?
        monkeys[monkey.next_monkeys[test]].items << item  # throw item
      end

      monkey.counter += monkey.items.length

      monkey.items = [] # empty items // monkey threw all away
    end
  end

  monkeys.collect { |m| m.counter } .sort[-2..-1].inject(&:*)
end

def monkey_business_2(lines, rounds)
  monkeys = monkeys(lines)

  # Monkeys' test divisors are all prime, their lowest common denominator is their product.
  # Should an item be of size (lcd + mod), where mod < lcd, the divisibility of item by any component of lcd depends solely on 
  # the divisibility of mod, since lcd is by definition divisible by it.
  # Therefore, we can guard against extreme growth of item by replacing it with its modulo by lcd, and still keep its future divisibility properties
  lcd = monkeys.collect { |m| m.divisor } .inject(&:*)

  rounds.times do
    monkeys.each do |monkey|
      monkey.items.each do |item|
        item = item.send(monkey.operation[:op], monkey.operation[:value] == "old" ? item : monkey.operation[:value].to_i) # monkey inspects
        
        item %= lcd # guard growth
        
        test = item % monkey.divisor == 0 # divisible?
        monkeys[monkey.next_monkeys[test]].items << item  # throw item
      end

      monkey.counter += monkey.items.length

      monkey.items = [] # empty items // monkey threw all away
    end
  end

  monkeys.collect { |m| m.counter } .sort[-2..-1].inject(&:*)
end
