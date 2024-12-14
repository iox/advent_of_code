class Grid
  attr_accessor :robots
  def initialize(width:, height:)
    @robots = []
    @width = width
    @height = height
  end

  def add_robot(x:, y:, velocity_x:, velocity_y:)
    @robots << Robot.new(x: x, y: y, velocity_x: velocity_x, velocity_y: velocity_y)
  end

  def move(n)
    @robots.each do |robot|
      robot.move(n, @width, @height)
    end
  end

  def any_robot_overlaps?
    @robots.combination(2).any? do |a, b|
      a.x == b.x && a.y == b.y
    end
  end

  def quadrants
    top_left_count = 0
    top_right_count = 0
    bottom_left_count = 0
    bottom_right_count = 0

    @robots.each do |robot|
      next if robot.x == @width / 2 || robot.y == @height / 2
      if robot.x < @width / 2 && robot.y < @height / 2
        top_left_count += 1
      elsif robot.x > @width / 2 && robot.y < @height / 2
        top_right_count += 1
      elsif robot.x < @width / 2 && robot.y > @height / 2
        bottom_left_count += 1
      else
        bottom_right_count += 1
      end
    end

    [top_left_count, top_right_count, bottom_left_count, bottom_right_count]
  end

  def print_state
    @height.times do |y|
      @width.times do |x|
        if @robots.any? {|r| r.x == x && r.y == y}
          print "#"
        else
          print "."
        end
      end
      puts
    end
  end
end

class Robot
  attr_accessor :x, :y, :velocity_x, :velocity_y
  def initialize(x:, y:, velocity_x:, velocity_y:)
    @x = x
    @y = y
    @velocity_x = velocity_x
    @velocity_y = velocity_y
  end

  def move(n, width, height)
    @x += @velocity_x * n
    @x = @x % width
    @y += @velocity_y * n
    @y = @y % height
  end
end


def parse(input:, width:, height:)
  grid = Grid.new(width: width, height: height)
  input.strip.split("\n").each do |line|
    x = line.split(",")[0].split("=")[1].to_i
    y = line.split(",")[1].split(" ")[0].to_i
    velocity_x = line.split(",")[1].split("=")[1].to_i
    velocity_y = line.split(",")[2].to_i
    grid.add_robot(x: x, y: y, velocity_x: velocity_x, velocity_y: velocity_y)
  end
  grid
end

def part1(input:, width:, height:)
  grid = parse(input: input, width: width, height: height)
  grid.move(100)
  grid.quadrants.reduce(:*)
end



def part2(input:, width:, height:)
  grid = parse(input: input, width: width, height: height)

  count = 0
  loop do
    if !grid.any_robot_overlaps?
      puts "No overlaps after #{count} seconds"  
      grid.print_state
      break
    end
    
    puts "Iterations: #{count}" if count % 100 == 0

    grid.move(1)
    count += 1
  end
end




puts part1(input: File.read("day14.txt"), width: 101, height: 103)
puts part2(input: File.read("day14.txt"), width: 101, height: 103)





require 'minitest/autorun'
require 'minitest/color'

class TestDay14 < Minitest::Test
  def minisample
    <<-EOF
    p=2,4 v=2,-3
    EOF
  end
  def sample
    <<-EOF
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    EOF
  end
  def test_part1
    grid = parse(input: minisample, width: 11, height: 7)
    assert_equal 2, grid.robots[0].x
    assert_equal 4, grid.robots[0].y
    assert_equal 2, grid.robots[0].velocity_x
    assert_equal -3, grid.robots[0].velocity_y
    assert_equal [0,0,1,0], grid.quadrants
    
    grid_sample_a = parse(input: minisample, width: 11, height: 7)
    grid_sample_a.move(1)
    assert_equal 4, grid_sample_a.robots[0].x
    assert_equal 1, grid_sample_a.robots[0].y
    assert_equal [1,0,0,0], grid_sample_a.quadrants

    grid_sample_b = parse(input: minisample, width: 11, height: 7)
    grid_sample_b.move(2)
    assert_equal 6, grid_sample_b.robots[0].x
    assert_equal 5, grid_sample_b.robots[0].y
    assert_equal [0,0,0,1], grid_sample_b.quadrants
    
    grid_sample_c = parse(input: minisample, width: 11, height: 7)
    grid_sample_c.move(3)
    assert_equal [0,1,0,0], grid_sample_c.quadrants

    grid_sample_d = parse(input: minisample, width: 11, height: 7)
    grid_sample_d.move(4)
    assert_equal [0,0,0,1], grid_sample_d.quadrants
    
    grid_sample_e = parse(input: minisample, width: 11, height: 7)
    grid_sample_e.move(5)
    assert_equal 1, grid_sample_e.robots[0].x
    assert_equal 3, grid_sample_e.robots[0].y
    assert_equal [0,0,0,0], grid_sample_e.quadrants

    grid_sample_g = parse(input: sample, width: 11, height: 7)
    grid_sample_g.move(100)
    assert_equal [1,3,4,1], grid_sample_g.quadrants

    assert_equal 12, part1(input: sample, width: 11, height: 7)
  end
end