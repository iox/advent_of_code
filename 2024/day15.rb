class Grid
  attr_accessor :steps, :grid, :robot_x, :robot_y

  def initialize(input)
    @grid = input.split("\n\n")[0].split("\n").map(&:strip).map(&:chars)
    @boxes = []
    @steps = input.split("\n\n")[1].gsub("\n", "").strip.chars
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        case cell
        when "@"
          @robot_x = x
          @robot_y = y
        end
      end
    end
  end

  def boxes
    list = []
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        list << [y,x] if cell == "O"
      end
    end
    list
  end

  def render
    @grid.map do |row|
      "    " + row.join
    end.join("\n")
  end

  def move(skip_first: 0, max_steps: nil)
    step_count = 0
    @steps.each_with_index do |step, i|
      next if i < skip_first
      break if max_steps && max_steps == step_count
      case step
      when "^"
        move_up
      when "v"
        move_down
      when ">"
        move_right
      when "<"
        move_left
      end
      step_count += 1
    end
  end

  def move_up
    y = @robot_y.dup
    x = @robot_x.dup

    # Navigate to the left one block at a time
    boxes_to_be_moved = []
    loop do
      y -= 1
      if @grid[y][x] == "."
        # We found a space! Let's move the robot
        @grid[@robot_y][@robot_x] = "."
        @robot_y -= 1
        @grid[@robot_y][@robot_x] = "@"

        # And any boxes we have found along the way
        boxes_to_be_moved.each do |box|
          y,x = box
          @grid[y - 1][x] = "O"
        end
        break
      end
      if grid[y][x] == "#"
        # We hit a wall, do absolutely nothing this move
        break
      end
      if grid[y][x] == "O"
        boxes_to_be_moved << [y,x]
      end
    end
  end

  def move_down
    y = @robot_y.dup
    x = @robot_x.dup

    # Navigate to the left one block at a time
    boxes_to_be_moved = []
    loop do
      y += 1
      if @grid[y][x] == "."
        # We found a space! Let's move the robot
        @grid[@robot_y][@robot_x] = "."
        @robot_y += 1
        @grid[@robot_y][@robot_x] = "@"

        # And any boxes we have found along the way
        boxes_to_be_moved.each do |box|
          y,x = box
          @grid[y + 1][x] = "O"
        end
        break
      end
      if grid[y][x] == "#"
        # We hit a wall, do absolutely nothing this move
        break
      end
      if grid[y][x] == "O"
        boxes_to_be_moved << [y,x]
      end
    end
  end

  def move_right
    y = @robot_y.dup
    x = @robot_x.dup

    # Navigate to the left one block at a time
    boxes_to_be_moved = []
    loop do
      x += 1
      if @grid[y][x] == "."
        # We found a space! Let's move the robot
        @grid[@robot_y][@robot_x] = "."
        @robot_x += 1
        @grid[@robot_y][@robot_x] = "@"

        # And any boxes we have found along the way
        boxes_to_be_moved.each do |box|
          y,x = box
          @grid[y][x + 1] = "O"
        end
        break
      end
      if grid[y][x] == "#"
        # We hit a wall, do absolutely nothing this move
        break
      end
      if grid[y][x] == "O"
        boxes_to_be_moved << [y,x]
      end
    end
  end

  def move_left
    y = @robot_y.dup
    x = @robot_x.dup

    # Navigate to the left one block at a time
    boxes_to_be_moved = []
    loop do
      x -= 1
      if @grid[y][x] == "."
        # We found a space! Let's move the robot
        @grid[@robot_y][@robot_x] = "."
        @robot_x -= 1
        @grid[@robot_y][@robot_x] = "@"

        # And any boxes we have found along the way
        boxes_to_be_moved.each do |box|
          y,x = box
          @grid[y][x - 1] = "O"
        end
        break
      end
      if grid[y][x] == "#"
        # We hit a wall, do absolutely nothing this move
        break
      end
      if grid[y][x] == "O"
        boxes_to_be_moved << [y,x]
      end
    end
  end
end


class GridPart2
  attr_accessor :steps, :grid, :robot_x, :robot_y

  def initialize(input)
    @grid = input.split("\n\n")[0].split("\n").map(&:strip).map(&:chars)
    
    @steps = input.split("\n\n")[1].gsub("\n", "").gsub(" ", "").strip.chars
    @grid.each_with_index do |row, y|
      new_row = ""
      row.each_with_index do |cell, x|
        case cell
        when "#"
          new_row += "##"
        when "."
          new_row += ".."
        when "O"
          new_row += "[]"
        when "@"
          new_row += "@."
          @robot_x = x*2
          @robot_y = y
        end
      end
      @grid[y] = new_row.chars
    end
  end

  def boxes
    list = []
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        list << [y,x] if cell == "["
      end
    end
    list
  end

  def render
    @grid.map do |row|
      "    " + row.join
    end.join("\n")
  end

  def move(skip_first: 0, max_steps: nil)
    step_count = 0
    @steps.each_with_index do |step, i|
      next if i < skip_first
      break if max_steps && max_steps == step_count
      case step
      when "^"
        move_up
      when "v"
        move_down
      when ">"
        move_right
      when "<"
        move_left
      else
        raise "WTFISTHIS #{step.inspect}"
      end
      step_count += 1
    end
  end

  def move_up
    y = @robot_y.dup
    x = @robot_x.dup

    # I can think of it as a queue! We initialize with the robot
    elements_to_be_moved = [
      [@robot_y, [@robot_x]]
    ]

    # Next we do a loop until we hit a wall or enough space to move
    loop do
      y,x_region = elements_to_be_moved.last
      
      # Check for any walls
      x_region.each do |x|
        if @grid[y-1][x] == "#"
          return # Hit a wall! Stop immediately! No movement
        end
      end

      # Check for spaces to move
      if x_region.all?{|x| @grid[y-1][x] == "."}
        break
      end

      # Check for any boxes to add to the queue
      next_x_region = []
      x_region.each do |x|
        if @grid[y-1][x] == "["
          next_x_region << x
          next_x_region << x + 1
        end
        if @grid[y-1][x] == "]"
          next_x_region << x - 1
          next_x_region << x
        end
      end
      elements_to_be_moved << [y-1, next_x_region.uniq]
    end

    # Now that we have found spaces to move, we move all of the elements one by one
    elements_to_be_moved.reverse.each do |element|
      y,x_region = element
      x_region.each do |x|
        @grid[y-1][x] = @grid[y][x]
        @grid[y][x] = "."
      end
    end

    # And don't forget to move the robot!
    @robot_y -= 1
  end

  def move_down
    y = @robot_y.dup
    x = @robot_x.dup

    # I can think of it as a queue! We initialize with the robot
    elements_to_be_moved = [
      [@robot_y, [@robot_x]]
    ]

    # Next we do a loop until we hit a wall or enough space to move
    loop do
      y,x_region = elements_to_be_moved.last
      
      # Check for any walls
      x_region.each do |x|
        if @grid[y+1][x] == "#"
          return # Hit a wall! Stop immediately! No movement
        end
      end

      # Check for spaces to move
      if x_region.all?{|x| @grid[y+1][x] == "."}
        break
      end

      # Check for any boxes to add to the queue
      next_x_region = []
      x_region.each do |x|
        if @grid[y+1][x] == "["
          next_x_region << x
          next_x_region << x + 1
        end
        if @grid[y+1][x] == "]"
          next_x_region << x - 1
          next_x_region << x
        end
      end
      elements_to_be_moved << [y+1, next_x_region.uniq]
    end

    # Now that we have found spaces to move, we move all of the elements one by one
    elements_to_be_moved.reverse.each do |element|
      y,x_region = element
      x_region.each do |x|
        @grid[y+1][x] = @grid[y][x]
        @grid[y][x] = "."
      end
    end

    # And don't forget to move the robot!
    @robot_y += 1
  end

  def move_right
    y = @robot_y.dup
    x = @robot_x.dup

    # Navigate to the left one block at a time
    boxes_to_be_moved = []
    loop do
      x += 1
      if @grid[y][x] == "."
        # First move the robot
        @grid[@robot_y][@robot_x] = "."
        @robot_x += 1
        @grid[@robot_y][@robot_x] = "@"

        # And any boxes we have found along the way
        boxes_to_be_moved.each do |box|
          y,x = box
          @grid[y][x + 2] = "]"
          @grid[y][x + 1] = "["    
        end

        break
      end
      if grid[y][x] == "#"
        # We hit a wall, do absolutely nothing this move
        break
      end
      if grid[y][x] == "["
        boxes_to_be_moved << [y,x]
      end
    end
  end

  def move_left
    y = @robot_y.dup
    x = @robot_x.dup

    # Navigate to the left one block at a time
    boxes_to_be_moved = []
    loop do
      x -= 1
      if @grid[y][x] == "."
        # puts "First move the robot"
        @grid[@robot_y][@robot_x] = "."
        @robot_x -= 1
        @grid[@robot_y][@robot_x] = "@"

        # And any boxes we have found along the way
        boxes_to_be_moved.each do |box|
          y,x = box
          @grid[y][x] = "]"
          @grid[y][x - 1] = "["    
        end

        break
      end
      if grid[y][x] == "#"
        # We hit a wall, do absolutely nothing this move
        break
      end
      if grid[y][x] == "]"
        boxes_to_be_moved << [y,x-1]
      end
    end
  end
end

def part1(input)
  grid = Grid.new(input)
  grid.move
  grid.boxes.map{|box| 100 * box[0] + box[1]}.reduce(:+)
end

def part2(input)
  grid = GridPart2.new(input)
  grid.move
  grid.boxes.map{|box| 100 * box[0] + box[1]}.reduce(:+)
end

puts part1(File.read("day15.txt"))
puts part2(File.read("day15.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test

  def sample
    <<-EOF
    ##########
    #..O..O.O#
    #......O.#
    #.OO..O.O#
    #..O@..O.#
    #O#..O...#
    #O..O..O.#
    #.OO.O.OO#
    #....O...#
    ##########

    <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    EOF
  end
  def sample_end_result
    <<-EOF
    ##########
    #.O.O.OOO#
    #........#
    #OO......#
    #OO@.....#
    #O#.....O#
    #O.....OO#
    #O.....OO#
    #OO....OO#
    ##########
    EOF
  end

  def minisample
    <<-EOF
    ########
    #..O.O.#
    ##@.O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    <^^>>>vv<v>>v<<
    EOF
  end

  def minisample_move_results
    move_list = <<-EOF
    Move <:
    ########
    #..O.O.#
    ##@.O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    Move ^:
    ########
    #.@O.O.#
    ##..O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    Move ^:
    ########
    #.@O.O.#
    ##..O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    Move >:
    ########
    #..@OO.#
    ##..O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    Move >:
    ########
    #...@OO#
    ##..O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    Move >:
    ########
    #...@OO#
    ##..O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    Move v:
    ########
    #....OO#
    ##..@..#
    #...O..#
    #.#.O..#
    #...O..#
    #...O..#
    ########

    Move v:
    ########
    #....OO#
    ##..@..#
    #...O..#
    #.#.O..#
    #...O..#
    #...O..#
    ########

    Move <:
    ########
    #....OO#
    ##.@...#
    #...O..#
    #.#.O..#
    #...O..#
    #...O..#
    ########

    Move v:
    ########
    #....OO#
    ##.....#
    #..@O..#
    #.#.O..#
    #...O..#
    #...O..#
    ########

    Move >:
    ########
    #....OO#
    ##.....#
    #...@O.#
    #.#.O..#
    #...O..#
    #...O..#
    ########

    Move >:
    ########
    #....OO#
    ##.....#
    #....@O#
    #.#.O..#
    #...O..#
    #...O..#
    ########

    Move v:
    ########
    #....OO#
    ##.....#
    #.....O#
    #.#.O@.#
    #...O..#
    #...O..#
    ########

    Move <:
    ########
    #....OO#
    ##.....#
    #.....O#
    #.#O@..#
    #...O..#
    #...O..#
    ########

    Move <:
    ########
    #....OO#
    ##.....#
    #.....O#
    #.#O@..#
    #...O..#
    #...O..#
    ######## 
    EOF

    clean_move_list = move_list.split("\n\n").map do |move_block|
      "    " + move_block.split(":\n")[1].strip
    end
    clean_move_list
  end

  def minisample_part2
    <<-EOF
    #######
    #...#.#
    #.....#
    #..OO@#
    #..O..#
    #.....#
    #######

    <vv<<^^<<^^
    EOF
  end

  def minisample_part2_expanded
    <<-EOF
    ##############
    ##......##..##
    ##..........##
    ##....[][]@.##
    ##....[]....##
    ##..........##
    ##############
    EOF
  end

  def minisample_part2_move_results
    move_list = <<-EOF
    Move <:
    ##############
    ##......##..##
    ##..........##
    ##...[][]@..##
    ##....[]....##
    ##..........##
    ##############

    Move v:
    ##############
    ##......##..##
    ##..........##
    ##...[][]...##
    ##....[].@..##
    ##..........##
    ##############

    Move v:
    ##############
    ##......##..##
    ##..........##
    ##...[][]...##
    ##....[]....##
    ##.......@..##
    ##############

    Move <:
    ##############
    ##......##..##
    ##..........##
    ##...[][]...##
    ##....[]....##
    ##......@...##
    ##############

    Move <:
    ##############
    ##......##..##
    ##..........##
    ##...[][]...##
    ##....[]....##
    ##.....@....##
    ##############

    Move ^:
    ##############
    ##......##..##
    ##...[][]...##
    ##....[]....##
    ##.....@....##
    ##..........##
    ##############

    Move ^:
    ##############
    ##......##..##
    ##...[][]...##
    ##....[]....##
    ##.....@....##
    ##..........##
    ##############

    Move <:
    ##############
    ##......##..##
    ##...[][]...##
    ##....[]....##
    ##....@.....##
    ##..........##
    ##############

    Move <:
    ##############
    ##......##..##
    ##...[][]...##
    ##....[]....##
    ##...@......##
    ##..........##
    ##############

    Move ^:
    ##############
    ##......##..##
    ##...[][]...##
    ##...@[]....##
    ##..........##
    ##..........##
    ##############

    Move ^:
    ##############
    ##...[].##..##
    ##...@.[]...##
    ##....[]....##
    ##..........##
    ##..........##
    ##############
    EOF

    clean_move_list = move_list.split("\n\n").map do |move_block|
      "    " + move_block.split(":\n")[1].strip
    end
    clean_move_list
  end

  def sample_part2_expanded
    <<-EOF
    ####################
    ##....[]....[]..[]##
    ##............[]..##
    ##..[][]....[]..[]##
    ##....[]@.....[]..##
    ##[]##....[]......##
    ##[]....[]....[]..##
    ##..[][]..[]..[][]##
    ##........[]......##
    ####################
    EOF
  end

  def sample_part2_end_result
    <<-EOF
    ####################
    ##[].......[].[][]##
    ##[]...........[].##
    ##[]........[][][]##
    ##[]......[]....[]##
    ##..##......[]....##
    ##..[]............##
    ##..@......[].[][]##
    ##......[][]..[]..##
    ####################
    EOF
  end

  def assert_grid(expectation, grid)
    if expectation.strip != grid.strip
      puts "Expected grid:"
      puts expectation
      puts "\n---------\n"
      puts "Actual grid:"
      puts grid
      puts "\n\n"
      assert_equal true, false
    else
      assert_equal true, true
    end
  end

  
  def test_part1
    minigrid = Grid.new(minisample)
    assert_equal "<^^>>>vv<v>>v<<".size, minigrid.steps.size
    assert_equal 6, minigrid.boxes.size

    assert_grid minisample.split("\n\n")[0], minigrid.render
        
    minisample_move_results.each_with_index do |expectation, i|
      minigrid.move(skip_first: i, max_steps: 1)
      assert_grid expectation, minigrid.render
    end

    assert_equal [1, 5], minigrid.boxes[0]
    assert_equal [1, 6], minigrid.boxes[1]
    assert_equal [3, 6], minigrid.boxes[2]
    assert_equal [4, 3], minigrid.boxes[3]
    
    assert_equal 2028, part1(minisample)
    assert_equal 10092, part1(sample)
  end

  def test_part2
    minigrid = GridPart2.new(minisample_part2)
    assert_equal 3, minigrid.boxes.size

    assert_grid minisample_part2_expanded, minigrid.render

    minisample_part2_move_results.each_with_index do |expectation, i|
      minigrid.move(skip_first: i, max_steps: 1)
      assert_grid expectation, minigrid.render
    end

    grid = GridPart2.new(sample)
    assert_grid sample_part2_expanded, grid.render
    grid.move
    assert_grid sample_part2_end_result, grid.render

    assert_equal 9021, part2(sample)
  end
end