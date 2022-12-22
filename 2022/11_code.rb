monkeys = []
File.read('11_example').split("\n\n").each do |monkey|
  lines = monkey.split("\n")
  monkeys << {
    items: lines[1].split("Starting items: ")[1].split(", ").map(&:to_i),
    operand: lines[2].split(" ")[4],
    amount: lines[2].split(" ")[5].to_i,
    divisible: lines[3].split(" ")[3].to_i,
    when_true: lines[4].split(" ")[5].to_i,
    when_false: lines[5].split(" ")[5].to_i,
    inspections: 0
  }
end

all_modules = monkeys.map{|m| m[:divisible]}.reduce(:*)

pp monkeys.map{|m| m[:divisible]}

debug = false

10000.times.with_index do |i|
  monkeys.each_with_index do |monkey, index|
    puts "Monkey #{index}:" if debug
    monkey[:items].each do |i|
      monkey[:inspections] += 1
      puts "  Monkey inspects an item with a worry level of #{i}." if debug
      amount = monkey[:amount] == 0 ? i : monkey[:amount]
      new_item = i.send(monkey[:operand], amount)
      puts "    Worry level is #{monkey[:operand]} by #{amount} to #{new_item}." if debug
      # new_item = new_item / 3
      new_item = new_item % all_modules
      # puts "    Monkey gets bored with item. Worry level is divided by 3 to #{new_item}." if debug
      if new_item % monkey[:divisible] == 0
        puts "    Current worry level is divisible by #{monkey[:divisible]}."  if debug
        puts "    Item with worry level #{new_item} is thrown to monkey #{monkey[:when_true]}."  if debug
        monkeys[monkey[:when_true]][:items] << new_item
      else
        puts "    Current worry level is not divisible by #{monkey[:divisible]}." if debug
        puts "    Item with worry level #{new_item} is thrown to monkey #{monkey[:when_false]}."  if debug
        monkeys[monkey[:when_false]][:items] << new_item
      end
    end
    monkey[:items] = []
  end

  if i == 0 || (i+1)%20 == 0
    puts "== After round #{i+1} =="
    monkeys.each_with_index do |monkey, index|
      puts "Monkey #{index} inspected items #{monkey[:inspections]} times."
    end
  end


end


puts monkeys.map{|m| m[:inspections]}.max(2).reduce(:*)