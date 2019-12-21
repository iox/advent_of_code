#! /usr/bin/env ruby

load 'intcode.rb'

module Something
  # def calculate(input)
  #   runner = Intcode.new(memory: input)
  #   painted_panels = []

  #   all_panels = Hash.new(0)
  #   current_position = [0,0]
  #   current_direction = 'up'

  #   color_to_paint_instruction = nil


  #   loop do
  #     if runner.status == 'waiting_for_input'
  #       current_color = all_panels[current_position]
  #       puts "The robot is asking about the current color. We are at #{current_position} and the color if #{current_color}"
  #       runner.enter_input(current_color)
  #     elsif runner.status == 'paused'
  #       if color_to_paint_instruction.nil?
  #         puts "\n\nThe robot has output a paint instruction with the color #{runner.output}. Painting it at #{current_position}"
  #         color_to_paint_instruction = runner.output
  #         all_panels[current_position] = color_to_paint_instruction
  #         painted_panels << current_position
  #         runner.run
  #       else
  #         puts "\n\nCurrent direction is #{current_direction}. The robot has output a turn instruction #{runner.output} (#{runner.output == 0 ? 'left' : 'right'})"
  #         current_direction = turn(current_direction, runner.output)
  #         puts "We have turned and now the current direction is #{current_direction}"

  #         puts "\n\nCurrent position is #{current_position}. It's time to move forward 1 pixel."
  #         current_position = move(current_position, current_direction)
  #         puts "We have moved and now the current position is #{current_position}"
  #         color_to_paint_instruction = nil
  #         runner.run
  #       end
  #     elsif runner.status == 'finished'
  #       break
  #     else
  #       runner.run
  #     end
  #   end


  #   painted_panels.uniq.size
  # end






  def calculate_b(input)
    runner = Intcode.new(memory: input)
    painted_panels = []

    all_panels = Hash.new(0)
    current_position = [0,0]
    current_direction = 'up'
    
    all_panels[current_position] = 1 # Paint the first panel white

    color_to_paint_instruction = nil


    loop do
      if runner.status == 'waiting_for_input'
        current_color = all_panels[current_position]
        puts "The robot is asking about the current color. We are at #{current_position} and the color if #{current_color}"
        runner.enter_input(current_color)
      elsif runner.status == 'paused'
        if color_to_paint_instruction.nil?
          puts "\n\nThe robot has output a paint instruction with the color #{runner.output}. Painting it at #{current_position}"
          color_to_paint_instruction = runner.output
          all_panels[current_position] = color_to_paint_instruction
          painted_panels << current_position
          runner.run
        else
          puts "\n\nCurrent direction is #{current_direction}. The robot has output a turn instruction #{runner.output} (#{runner.output == 0 ? 'left' : 'right'})"
          current_direction = turn(current_direction, runner.output)
          puts "We have turned and now the current direction is #{current_direction}"

          puts "\n\nCurrent position is #{current_position}. It's time to move forward 1 pixel."
          current_position = move(current_position, current_direction)
          puts "We have moved and now the current position is #{current_position}"
          color_to_paint_instruction = nil
          runner.run
        end
      elsif runner.status == 'finished'
        break
      else
        runner.run
      end
    end


    puts all_panels


    painted_panels.uniq.size

    for x in (-50..50)
      puts (-50..50).to_a.map{|y| all_panels[[x,y]] == 0 ? ' ' : 1}.join
    end
  end












  def turn(current_direction, direction_instruction)
    if direction_instruction == 0
      return turn_left(current_direction)
    else
      return turn_right(current_direction)
    end
  end


  def turn_left(current_direction)
    return 'left' if current_direction == 'up'
    return 'up' if current_direction == 'right'
    return 'right' if current_direction == 'down'
    return 'down' if current_direction == 'left'
  end

  def turn_right(current_direction)
    return 'right' if current_direction == 'up'
    return 'down' if current_direction == 'right'
    return 'left' if current_direction == 'down'
    return 'up' if current_direction == 'left'
  end

  def move(current_position, direction)
    if direction == 'up'
      return [current_position[0], current_position[1]+1]
    end
    if direction == 'right'
      return [current_position[0]+1, current_position[1]]
    end
    if direction == 'down'
      return [current_position[0], current_position[1]-1]
    end
    if direction == 'left'
      return [current_position[0]-1, current_position[1]]
    end
  end

end


if !ARGV.include?("run")
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
    end
  end

else
  include Something


  
  puts calculate_b(File.read('11_input').split(',').map(&:to_i))
  
end
