# watch -c "ruby day5.rb"
# Press F5 to start debugger or "rdbg day5.rb"


def parse(input)
  rules = {}
  input.split("\n\n")[0].split("\n").each do |r|
    numbers = r.strip.split("|").map(&:to_i)
    rules[numbers[0]] ||= []
    rules[numbers[0]] << numbers[1]
  end

  updates = input.split("\n\n")[1].split("\n").map{|u| u.strip.split(",").map(&:to_i)}

  return rules, updates
end


def part1(input)
  rules, updates = parse(input)
  count = 0
  updates.each do |u|
    if valid?(rules, u)
      count += u[u.length / 2]
    end
  end
  count
end




def part2(input)
  rules, updates = parse(input)
  count = 0
  updates.each do |u|
    if !valid?(rules, u)
      fixed_update = fix_order(u, rules)
      count += fixed_update[fixed_update.length / 2]
    end
  end
  count
end



def valid?(rules, u)
  previous = []
  u.each do |n|
    rule = rules[n]
    if rule && previous.any?{|prev| rule.include?(prev)}
      return false
    end
    previous << n
  end
  return true
end

def fix_order(update, rules)
  fixed = []

  # return [97,75] if update == [75,97]
  # We know that 97 needs to be before [13, 61, 47, 29, 53, 75]
  # We know that 75 needs to be before [29, 53, 47, 61, 13]

  # 97 => [75]
  # 75 => []

  # Start with the one which has no dependencies
  # 75

  # Then repeat the logic with the other X amount of numbers until there are no numbers left
  loop do
    break if update.length == 0
    update.each do |number|
      has_any_dependency = rules[number] && rules[number].any?{|r| update.include?(r)}
      if !has_any_dependency
        fixed << number
        update.delete(number)
      end
    end
  end

  fixed.reverse
end





puts part1(File.read("2024/day5.txt"))
puts part2(File.read("2024/day5.txt"))


require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    sample = <<-EOF
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    EOF
  end

  def test_part1
    rules, updates = parse(sample)
    assert_equal 143, part1(sample)
  end

  def test_part2
    rules, updates = parse(sample)
    assert_equal valid?(rules, [75,97]), false
    assert_equal valid?(rules, [97,75]), true

    assert_equal [97,75], fix_order([75,97], rules)


    assert_equal valid?(rules, [75,97,47,61,53]), false
    assert_equal [97,75,47,61,53], fix_order([75,97,47,61,53], rules)

    assert_equal [61,29,13], fix_order([61,13,29], rules)
    assert_equal [97,75,47,29,13], fix_order([97,13,75,29,47], rules)
    assert_equal 123, part2(sample)
  end



end