# watch -c "ruby day4.rb"
# Press F5 to start debugger or "rdbg day4.rb"


def parse(input)
  input.split("\n").map(&:strip).map(&:chars)
end

def get_horizontal(grid)
  grid.map { |line| line.join } + grid.map { |line| line.join.reverse }
end

def get_vertical(grid)
  grid.transpose.map { |line| line.join } + grid.transpose.map { |line| line.join.reverse }
end


def counter(str, sub)
  str.scan(/(?=#{sub})/).count
end


def get_descending_starting_points(grid)
  width = grid[0].length
  height = grid.length

  descending = []

  # first row positions
  y = 0
  width.times do |x|
    descending << [y, x]
  end

  # first column positions
  x = 0
  height.times do |y|
    descending << [y, x]
  end

  descending.uniq
end



def get_ascending_starting_points(grid)
  width = grid[0].length
  height = grid.length

  ascending = []

  # first column positions
  x = 0
  height.times do |y|
    ascending << [y, x]
  end

  # last row positions
  y = height - 1
  width.times do |x|
    ascending << [y, x]
  end

  ascending.uniq
end


def get_diagonal(grid)
  lines = []
  get_descending_starting_points(grid).each do |point|
    diff = 0
    line = ""
    loop do
      y = point[0]+diff
      x = point[1]+diff
      letter = grid[y][x] if grid[y]
      if letter
        line += letter
        diff += 1
      else
        break
      end
    end
    lines << line if line != ""
  end

  get_ascending_starting_points(grid).each do |point|
    diff = 0
    line = ""
    loop do
      y = point[0]-diff
      x = point[1]+diff
      break if y < 0
      break if grid[y] == nil
      letter = grid[y][x]
      if letter
        line += letter
        diff += 1
      else
        break
      end
    end
    lines << line if line != ""
  end

  lines + lines.map(&:reverse)
end



def part1(input)
  grid = parse(input)
  all_lines = get_horizontal(grid) + get_vertical(grid) + get_diagonal(grid)
  
  horizonal_lines_with_xmas = get_horizontal(grid).select{|line| line.include?("XMAS")}
  vertical_lines_with_xmas = get_vertical(grid).select{|line| line.include?("XMAS")}
  diagonal_lines_with_xmas = get_diagonal(grid).select{|line| line.include?("XMAS")}

  all_lines.map { |line| counter(line, "XMAS") }.reduce(:+)
end






def christmas_block?(grid, y, x)
  top_left = grid[y-1][x-1] if grid[y-1] && grid[y-1][x-1] && y > 0 && x >0
  top_right = grid[y-1][x+1] if grid[y-1] && grid[y-1][x+1] && y > 0
  bottom_left = grid[y+1][x-1] if grid[y+1] && grid[y+1][x-1] && x > 0
  bottom_right = grid[y+1][x+1] if grid[y+1] && grid[y+1][x+1]
  descending = [top_left, bottom_right]
  ascending = [bottom_left, top_right]

  return true if descending.include?("M") && descending.include?("S") && ascending.include?("M") && ascending.include?("S")

  false
end

def part2(input)
  grid = parse(input)
  count = 0
  grid.each_with_index do |line, y|
    line.each_with_index do |char, x|
      if char == "A" && christmas_block?(grid, y, x)
        count += 1
      end
    end
  end
  count
end



puts part1(File.read("day4.txt"))
puts part2(File.read("day4.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def test_part1
    even_simpler_sample = <<-EOF
    ABC
    DEF
    EOF

    even_simpler_grid = parse(even_simpler_sample)
    descending = get_descending_starting_points(even_simpler_grid)
    ascending = get_ascending_starting_points(even_simpler_grid)

    assert_equal [0,0], descending[0]
    assert_equal [0,1], descending[1]
    assert_equal [0,2], descending[2]
    assert_equal [1,0], descending[3]
    assert_nil descending[4]

    assert_equal [0, 0], ascending[0]
    assert_equal [1, 0], ascending[1]
    assert_equal [1, 1], ascending[2]
    assert_equal [1, 2], ascending[3]
    assert_nil ascending[4]

    diagonal_lines = get_diagonal(even_simpler_grid)
    assert_equal "AE", diagonal_lines[0]
    assert_equal "BF", diagonal_lines[1]
    assert_equal "C", diagonal_lines[2]
    assert_equal "D", diagonal_lines[3]

    assert_equal 2, counter("mamama", "mama")


    simple_sample = <<-EOF
    ..X...
    .SAMX.
    .A..A.
    XMAS.S
    .X....
    EOF

    grid = parse(simple_sample)
    horizontal_lines = get_horizontal(grid)
    vertical_lines = get_vertical(grid)
    diagonal_lines = get_diagonal(grid)


    assert_equal "..X...", horizontal_lines[0]
    assert_equal "XMAS.S", horizontal_lines[3]
    assert_equal "...X..", horizontal_lines[5] # First row in reverse
    assert_equal "...X.", vertical_lines[0]
    assert_equal ".X...", vertical_lines[6] # First column in reverse
    assert_equal "XMAS.", vertical_lines[7]

    assert_equal ".S.S.", diagonal_lines[0]
    assert_equal ".A...", diagonal_lines[1]
    assert_equal "XMAS", diagonal_lines[2]

    assert_equal 4, part1(simple_sample)

    sample = <<-EOF
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
      EOF

    
    
    assert_equal 18, part1(sample)
  end

  def test_part2
    sample = <<-EOF
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
    EOF
    grid = parse(sample)
    assert_equal true, christmas_block?(grid, 1, 2)
    assert_equal false, christmas_block?(grid, 1, 3)
    assert_equal true, christmas_block?(grid, 2, 6)
    assert_equal 9, part2(sample)
  end

end