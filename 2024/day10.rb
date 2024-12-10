def parse(input)
  input.split("\n").map(&:strip).map do |line|
    line.chars.map do |c|
      c == "." ? nil : c.to_i
    end
  end
end

def find_trailheads(input)
  grid = parse(input)
  trailheads = []
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if cell == 0
        trailheads << [y, x]
      end
    end
  end
  trailheads
end

def score(input, trailhead, count_all_paths=false)
  grid = parse(input)

  # We initilize the queue with our starting point
  queue = [trailhead]
  final_positions = []

  loop do
    break if queue.empty?

    y, x = queue.pop

    current_value = grid[y][x]
    if current_value == 9
      final_positions << "#{y}-#{x}" if count_all_paths || !final_positions.include?("#{y}-#{x}")
      next
    end

    # Look to the right
    right = grid[y][x+1] if grid[y]
    queue << [y, x+1] if right == current_value + 1
    # Left
    left = grid[y][x-1] if grid[y] && x > 0 
    queue << [y, x-1] if left == current_value + 1
    # Up
    up = grid[y-1][x] if y > 0 && grid[y-1]
    queue << [y-1, x] if up == current_value + 1
    # Down
    down = grid[y+1][x] if grid[y+1]
    queue << [y+1, x] if down == current_value + 1
  end

  return final_positions.count
end


def part1(input)
  find_trailheads(input).map{|t| score(input, t)}.reduce(:+)
end

def part2(input)
  find_trailheads(input).map{|t| score(input, t, true)}.reduce(:+)
end

puts part1(File.read("day10.txt"))
puts part2(File.read("day10.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample_a
    <<-EOF
    0123
    1234
    8765
    9876
    EOF
  end

  def sample_b
    <<-EOF
    ...0...
    ...1...
    ...2...
    6543456
    7.....7
    8.....8
    9.....9
    EOF
  end

  def sample_c
    <<-EOF
    ..90..9
    ...1.98
    ...2..7
    6543456
    765.987
    876....
    987....
    EOF
  end

  def sample_d
    <<-EOF
    10..9..
    2...8..
    3...7..
    4567654
    ...8..3
    ...9..2
    .....01
    EOF
  end

  def sample_e
    <<-EOF
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    EOF
  end

  def sample_f
    <<-EOF
    .....0.
    ..4321.
    ..5..2.
    ..6543.
    ..7..4.
    ..8765.
    ..9....
    EOF
  end


  def test_find_trailheads
    assert_equal [[0,0]], find_trailheads(sample_a)
    assert_equal [[0,1],[6,5]], find_trailheads(sample_d)
  end

  def test_score
    assert_equal 1, score(sample_a, [0,0])
    assert_equal 2, score(sample_b, [0, 3])
    assert_equal 4, score(sample_c, [0, 3])
    assert_equal 1, score(sample_d, [0, 1])
    assert_equal 2, score(sample_d, [6, 5])
    sample_e_scores = find_trailheads(sample_e).map{|t| score(sample_e, t)}
    assert_equal [5,6,5,3,1,3,5,3,5], sample_e_scores
  end

  def test_part1
    assert_equal 3, part1(sample_d)
    assert_equal 36, part1(sample_e)
  end


  def test_score_part2
    assert_equal 3, score(sample_f, [0,5], true)
  end
end