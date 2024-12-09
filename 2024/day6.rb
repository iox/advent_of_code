# watch -c "ruby day6.rb"
# Press F5 to start debugger or "rdbg day6.rb"


def part1_walk(input, max_iterations=nil)
  map = input.split("\n").map(&:strip)
  start_line = map.select{|l| l.include?("^")}[0]
  x = start_line.index("^")
  y = map.index(start_line)
  direction = "^"

  iterations = 0
  while true
    if max_iterations && iterations >= max_iterations
      break
    end

    case direction
    when "^"
      next_y = y - 1
      next_x = x
    when "v"
      next_y = y + 1
      next_x = x
    when "<"
      next_y = y
      next_x = x - 1
    when ">"
      next_y = y
      next_x = x + 1
    end

    if next_y < 0 || next_y < 0 || map[next_y] == nil || map[next_y][next_x] == nil
      # puts "Leaving the area!"
      break
    end

    if map[next_y][next_x] == "#"
      direction = case direction
      when "^"
        ">"
      when ">"
        "v"
      when "v"
        "<"
      when "<"
        "^"
      end

      next
    end

    if map[next_y][next_x] == "." || map[next_y][next_x] == "X"
      map[y][x] = "X"
      map[next_y][next_x] = direction
      x = next_x
      y = next_y
    end

    iterations += 1
    # result = "    " +map.join("\n    ")+"\n"
    # puts "After #{iterations} iterations\n____________________\n#{result}"
  end

  result = "    " +map.join("\n    ")+"\n"

  result
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end




def part2_walk(input, blocking_position)
  map = input.split("\n").map(&:strip)
  start_line = map.select{|l| l.include?("^")}[0]
  x = start_line.index("^")
  y = map.index(start_line)
  direction = "^"
  # sleep_time = 0.02

  # Start position can not be blocking position
  if [y,x] == blocking_position
    return false
  end

  # Set blocking position in map
  chars = map[blocking_position[0]].chars
  chars[blocking_position[1]] = "O"
  map[blocking_position[0]] = chars.join("")

  # Store old positions
  old_positions = []
  iterations = 0
  
  while true

    # Calculate the next position we want to move to
    case direction
    when "^"
      next_y = y - 1
      next_x = x
    when "v"
      next_y = y + 1
      next_x = x
    when "<"
      next_y = y
      next_x = x - 1
    when ">"
      next_y = y
      next_x = x + 1
    end

    # With the next position, if it is is outside the area, return false
    if next_y < 0 || next_x < 0 || map[next_y] == nil || map[next_y][next_x] == nil
      # puts "Leaving the area!"
      return false
    end

    # With the next position, check if we can move there. If not, TURN
    if map[next_y][next_x] == "#" || map[next_y][next_x] == "O"
      # if map[next_y][next_x] == "O"
      #   sleep_time = 0.1
      # end
      direction = case direction
      when "^"
        ">"
      when ">"
        "v"
      when "v"
        "<"
      when "<"
        "^"
      end

      next
    end

    # We are definitely going to move! Check if we have been here before
    if old_positions.include?("#{direction}-x#{x}-y#{y}")
      puts "Loop detected! blocking position #{blocking_position}".yellow
      # puts "After #{iterations} iterations, direction is #{direction}\n____________________\n"
      # result = ("    " +map.join("\n    ")+"\n").gsub(".", " ").gsub("X", "·").gsub("^","^".yellow).gsub("v","v".yellow).gsub("<","<".yellow).gsub(">",">".yellow)
      # puts result

      return blocking_position
    end

    # Store the current position in the list of visited positions
    old_positions << "#{direction}-x#{x}-y#{y}"

    # Move if we hit a free space
    if map[next_y][next_x] == "." || map[next_y][next_x] == "X"
      map[y][x] = "X"
      map[next_y][next_x] = direction
      x = next_x
      y = next_y

      # puts "\n\n\n\n----------------\n\n\n\n"
      # result = ("    " +map.join("\n    ")+"\n").gsub(".", " ").gsub("X", "·").gsub("^","^".yellow).gsub("v","v".yellow).gsub("<","<".yellow).gsub(">",">".yellow)
      # puts result
      # sleep sleep_time
    else
      raise "ERROR"
    end

    iterations += 1
  end

  result = "    " +map.join("\n    ")+"\n"

  result
end


def part1(input)
  result = part1_walk(input)
  result.count("X")+1
end


def part2(input)
  possible_block_positions = []
  standard_path = part1_walk(input).gsub("^", "X").gsub("v", "X").gsub("<", "X").gsub(">", "X")
  standard_path.split("\n").each_with_index do |line,y|
    line.strip.chars.each_with_index do |char, x|
      possible_block_positions << [y,x] if char == "X"
    end
  end

  possible_block_positions = possible_block_positions

  # fucking_wrong_positions = [[1, 20], [4, 20], [12, 5], [12, 7], [12, 8], [12, 20], [23, 20], [25, 12], [25, 30], [83, 27]]

  #   count = 0
  #   fucking_wrong_positions.each_with_index do |pos, i|
  #     if part2_walk(input.dup, pos)
  #       puts "Iteration: #{i}. Loops: #{count}. Last loop found at #{pos}!".green
  #       count += 1
  #       raise "STOP HERE"
  #     end 
  #   end
  #   return count


  require 'parallel'

  count = 0

  puts "Possible block positions: #{possible_block_positions.count}"

  results = Parallel.map_with_index(possible_block_positions, in_processes: 20) do |pos, i|
    puts "Progress: #{i}/#{possible_block_positions.count}"
    part2_walk(input, pos)
  end

  my_valid_positions = results.reject{|r| r == false}

  puts my_valid_positions.inspect
  
  puts "COUNT: #{my_valid_positions.count}"

  my_valid_positions.count

end






# puts part1(File.read("day6.txt"))
puts part2(File.read("day6cameron.txt"))


require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    <<-EOF
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    EOF
  end

  def after_5_sample
    <<-EOF
    ....#.....
    ....^....#
    ....X.....
    ..#.X.....
    ....X..#..
    ....X.....
    .#..X.....
    ........#.
    #.........
    ......#...
    EOF
  end

  def after_9_sample
    <<-EOF
    ....#.....
    ....XXXX>#
    ....X.....
    ..#.X.....
    ....X..#..
    ....X.....
    .#..X.....
    ........#.
    #.........
    ......#...
    EOF
  end

  def after_14_sample
    <<-EOF
    ....#.....
    ....XXXXX#
    ....X...X.
    ..#.X...X.
    ....X..#X.
    ....X...X.
    .#..X...v.
    ........#.
    #.........
    ......#...
    EOF
  end

  def end_state
    <<-EOF
    ....#.....
    ....XXXXX#
    ....X...X.
    ..#.X...X.
    ..XXXXX#X.
    ..X.X.X.X.
    .#XXXXXXX.
    .XXXXXXX#.
    #XXXXXXX..
    ......#v..
    EOF
  end

  # def test_part1
  #   assert_equal sample, part1_walk(sample, 0)
  #   assert_equal after_5_sample, part1_walk(sample, 5)
  #   assert_equal after_9_sample, part1_walk(sample, 9)
  #   assert_equal after_14_sample, part1_walk(sample, 14)

  #   assert_equal 41, (end_state.count("X")+1)
  #   assert_equal 41, part1(sample)
  # end

  # def test_part2
  #   assert_equal 6, part2(sample)
  # end

end