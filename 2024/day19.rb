def parser(input)
  patterns_block, designs_block = input.split("\n\n")
  patterns = patterns_block.split(",").map(&:strip)
  designs = designs_block.split("\n").map(&:strip)
  [patterns, designs]
end


def count_patterns(design, patterns, memory = {})
  return memory[design] if memory.key?(design)

  memory[design] = patterns.sum do |pattern|
    if design == pattern
      1
    elsif design.start_with?(pattern)
      count_patterns(design[pattern.size..], patterns, memory)
    else
      0
    end
  end

  memory[design]
end


def part1(input)
  patterns, designs = parser(input)
  results = designs.map do |design|
    count_patterns(design, patterns)
  end
  results.count(&:positive?)
end

def part2(input)
  patterns, designs = parser(input)
  results = designs.map do |design|
    count_patterns(design, patterns)
  end
  results.sum
end

puts part1(File.read("day19.txt"))
puts part2(File.read("day19.txt"))






require 'minitest/autorun'
require 'minitest/color'

class TestDay19 < Minitest::Test
  def sample
    <<-EOF
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
    EOF
  end
  def test_part1
    patterns, designs = parser(sample)
    assert_equal "r", patterns[0]
    assert_equal "br", patterns.last
    assert_equal "brwrr", designs[0]
    assert_equal "bbrgwb", designs.last

    assert_equal true, count_patterns("brwrr", patterns).positive?
    assert_equal true, count_patterns("bggr", patterns).positive?
    assert_equal true, count_patterns("gbbr", patterns).positive?
    assert_equal true, count_patterns("rrbgbr", patterns).positive?
    assert_equal false, count_patterns("ubwu", patterns).positive?
    assert_equal true, count_patterns("bwurrg", patterns).positive?
    assert_equal true, count_patterns("brgr", patterns).positive?
    assert_equal false, count_patterns("bbrgwb", patterns).positive?

    assert_equal 6, part1(sample)
  end

  def test_part2
    assert_equal 16, part2(sample)
  end
end