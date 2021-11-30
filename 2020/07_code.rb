
class Bag
  attr_reader :number, :color

  def initialize(number, color)
    @number = number
    @color = color
  end
end


def parse_rules(data)
  rules_text = data.split("\n").map(&:strip)
  rules = {}

  rules_text.each do |rule|
    parent_color = rule.split(" bags contain ")[0]
    content = rule.split(" contain ")[1]
    children = content.split(", ").map do |child|
      number, color = child.match(/(\d+) ([a-z ]*) bag/)&.captures
      if number
        Bag.new(number.to_i, color)
      end
    end.compact
    rules[parent_color] = children
  end
  return rules
end


def extract_parent_colors(rules, target_color)
  result = []
  rules.each do |parent_color, bags|
    if bags.any?{|bag| bag.color == target_color}
      result << parent_color
      result += extract_parent_colors(rules, parent_color)
    end
  end
  result
end


def count_children(rules, target_color)
  counter = 0
  rules[target_color].each do |bag|
    bag.number.times do
      counter += 1
      counter += count_children(rules, bag.color)
    end
  end
  return counter
end


def part1(data)
  rules = parse_rules(data)
  extract_parent_colors(rules, 'shiny gold').uniq!.size
end


def part2(data)
  rules = parse_rules(data)
  count_children(rules, 'shiny gold')
end



data = File.read('07_input')
puts "Part 1: #{part1(data)}"
puts "Part 2: #{part2(data)}"











def example_data
<<-EXAMPLEINPUT
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
EXAMPLEINPUT
end

def example_data_2
<<-EXAMPLEINPUT
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
EXAMPLEINPUT
end


if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part1
      assert_equal(4, part1(example_data))
    end

    def test_part2
      assert_equal(32, part2(example_data))
      assert_equal(126, part2(example_data_2))
    end
  end

  return
end
