#! /usr/bin/env ruby

load 'intcode.rb'

module Something
  def calculate(input) 
    tiles = get_tiles(input)
    oxygen_system_position = tiles.select{|k,v| v == 2}.keys.first

    puts "\n\nNow that tiles contains a complete map (#{tiles.keys.size} tiles), we need to know the minimum amount of steps to go from [0,0] to #{oxygen_system_position} (oxygen_system_position)"
    puts "\n\n\n"
    # I need to use something called BFS. that requires a queue (an array?) and a tree (a hash containing subhashes?)
    # I am going to create a collection of valid paths. All possible ways to reach the exit successfully
    valid_paths = []
    

    position = [0,0]
    visited_cells = []
    queue = [ [position] ]
    puts "Trying to reach #{tiles.select{|k,v| v == 2}.keys.first}"

    loop do
      if queue.size == 0
        # No more paths left to investigate
        break
      end

      current_path = queue.pop
      current_position = current_path.last
      visited_cells << current_position

      next_up = [current_position[0], current_position[1]+1]
      next_right = [current_position[0]+1, current_position[1]]
      next_left = [current_position[0]-1, current_position[1]]
      next_down = [current_position[0], current_position[1]-1]

      [next_up, next_right, next_left, next_down].each do |next_cell|
        if tiles[next_cell] == 0
          # puts "We hit a wall, do nothing"
        elsif tiles[next_cell] == 2
          new_path = current_path.dup
          new_path << next_cell
          valid_paths << new_path
        elsif (tiles[next_cell] == 1 || tiles[next_cell] == 'Droid')  && !visited_cells.include?(next_cell)
          new_path = current_path.dup
          new_path << next_cell
          queue << new_path
        end
      end
    end

    # Then, I am just going to take the shortest one
    valid_paths.first.size - 1
  end




  def calculate_b(input) 
    tiles = get_tiles(input)
    droid_position = tiles.select{|k,v| v == 'Droid'}.keys.first
    tiles[droid_position] = 1 # Mark the droid position with a 1 too, it's an empty space for the B challenge
    oxygen_system_position = tiles.select{|k,v| v == 2}.keys.first

    all_empty_tiles_positions = tiles.select{|k,v| v == 1}.keys

    puts "\n\nNow that tiles contains a complete map (#{tiles.keys.size} tiles), we need to start from #{oxygen_system_position} and fill all the '1' spaces: #{all_empty_tiles_positions.size} tiles"
    puts "\n\n\n"
    # I need to use something called BFS. that requires a queue (an array?) and a tree (a hash containing subhashes?)
    # I am going to create a collection of valid paths. All possible ways to reach the exit successfully
    valid_paths = []
    

    visited_cells = []
    queue = [ [oxygen_system_position] ]

    loop do
      if queue.size == 0
        # No more paths left to investigate
        break
      end

      current_path = queue.pop
      valid_paths << current_path.dup
      current_position = current_path.last
      visited_cells << current_position

      next_up = [current_position[0], current_position[1]+1]
      next_right = [current_position[0]+1, current_position[1]]
      next_left = [current_position[0]-1, current_position[1]]
      next_down = [current_position[0], current_position[1]-1]

      [next_up, next_right, next_left, next_down].each do |next_cell|
        if tiles[next_cell] == 0
          # puts "We hit a wall, do nothing"
        # elsif tiles[next_cell] == 2
        #   new_path = current_path.dup
        #   new_path << next_cell
        #   valid_paths << new_path
        elsif (tiles[next_cell] == 1)  && !visited_cells.include?(next_cell)
          new_path = current_path.dup
          new_path << next_cell
          queue << new_path
        end
      end
    end

    # Then, I am just going to take the shortest one
    valid_paths.map(&:size).max
  end










  def get_tiles(input) # Follow the right wall strategy. It takes... 0.15 seconds!!! Really amazing to see
    runner = Intcode.new(memory: input)
    runner.run

    position = [0,0]
    tiles = {}
    tiles[position] = 'Droid'
    direction = 'up'
    new_direction_if_empty = nil
    next_position = [0,0]
    oxygen_system_position = nil

    instruction_codes = {
      'up' => 1,
      'down' => 2,
      'left' => 3,
      'right' => 4
    }

    already_found = false

    loop do
      if runner.status == 'waiting_for_input'
        next_up = [position[0], position[1]+1]
        next_right = [position[0]+1, position[1]]
        next_left = [position[0]-1, position[1]]
        next_down = [position[0], position[1]-1]



        if direction == 'up' && tiles[next_right] != 0
          new_direction_if_empty = 'right'
        end
        if direction == 'right' && tiles[next_down] != 0
          new_direction_if_empty = 'down'
        end
        if direction == 'down' && tiles[next_left] != 0
          new_direction_if_empty = 'left'
        end
        if direction == 'left' && tiles[next_up] != 0
          new_direction_if_empty = 'up'
        end



        if (new_direction_if_empty || direction) == 'up'
          next_position = next_up
        elsif (new_direction_if_empty || direction) == 'left'
          next_position = next_left
        elsif (new_direction_if_empty || direction) == 'right'
          next_position = next_right
        elsif (new_direction_if_empty || direction) == 'down'
          next_position = next_down
        end




        if new_direction_if_empty
          # print_tiles(tiles: tiles, message: "Moving #{direction}, but we don't know what we have on #{new_direction_if_empty}, so trying #{new_direction_if_empty}")
          runner.enter_input(instruction_codes[new_direction_if_empty])
        else
          # print_tiles(tiles: tiles, message: "Moving #{direction}, no doubts! #{next_position}")
          runner.enter_input(instruction_codes[direction])
        end
             


      elsif runner.status == 'paused'
        if runner.output == 0 # Wall
          # puts "We have hit a wall"
          tiles[next_position] = 0
          # print_tiles(tiles: tiles, message: "We have hit a wall in #{next_position}. The droid continues stays in #{position}")
          if new_direction_if_empty  # we were expecting a wall, do nothing
            new_direction_if_empty = nil
          else # WTF, there is a wall in our direction. Let's turn left 90 degrees
            puts "WTF, there is a wall in our direction. Turning left!"
            if direction == 'up'
              direction = 'left'
            elsif direction == 'left'
              direction = 'down'
            elsif direction == 'down'
              direction = 'right'
            elsif direction == 'right'
              direction = 'up'
            end
          end
          puts "runner.run"
          runner.run


        elsif runner.output == 1 # Empty space
          puts "We have hit an empty space"
          tiles[position] = 1
          tiles[next_position] = 'Droid'
          position = next_position.dup
          if new_direction_if_empty
            direction = new_direction_if_empty.dup
            new_direction_if_empty = nil
          end
          puts "runner.run"
          runner.run



        elsif runner.output == 2 # TARGET!
          if already_found
            puts "JOB IS DONE, WE HAVE THE MAP"
            tiles[next_position] = 2
            print_tiles(tiles: tiles, message: "SUCCESS")
            break
          else
            puts "FOUND THE OXYGEN SYSTEM, BUT GIVING IT ANOTHER ROUND TO COMPLETE THE MAZE DRAWING! :)"
            already_found = true
            tiles[position] = 1
            tiles[next_position] = 'Droid'
            position = next_position.dup
            if new_direction_if_empty
              direction = new_direction_if_empty.dup
              new_direction_if_empty = nil
            end
            puts "runner.run"
            runner.run
          end
        end
      else
        raise "WTF #{runner.status}   #{runner.output}"
      end
    end

    tiles
  end



  







  def calculate_mouse(input) # Mouse strategy, takes around 3 to 20 seconds to go through the maze
    runner = Intcode.new(memory: input)
    runner.run

    position = [0,0]
    next_position = [0,0]
    tiles = {}
    tiles[position] = 'Droid'




    loop do
      
      # sleep 0.05
      if runner.status == 'waiting_for_input'
        next_position_up = [position[0], position[1]+1]
        next_position_right = [position[0]+1, position[1]]
        next_position_left = [position[0]-1, position[1]]
        next_position_down = [position[0], position[1]-1]


        empty_positions = []
        unknown_positions = []

        if tiles[next_position_up] == 1
          empty_positions << {direction: 'up', next_position: next_position_up, input: 1}
        elsif tiles[next_position_up].nil?
          unknown_positions << {direction: 'up', next_position: next_position_up, input: 1}
        end

        if tiles[next_position_right] == 1
          empty_positions << {direction: 'right', next_position: next_position_right, input: 4}
        elsif tiles[next_position_right].nil?
          unknown_positions << {direction: 'right', next_position: next_position_right, input: 4}
        end

        if tiles[next_position_down] == 1
          empty_positions << {direction: 'down', next_position: next_position_down, input: 2}
        elsif tiles[next_position_down].nil?
          unknown_positions << {direction: 'down', next_position: next_position_down, input: 2}
        end

        if tiles[next_position_left] == 1
          empty_positions << {direction: 'left', next_position: next_position_left, input: 3}
        elsif tiles[next_position_left].nil?
          unknown_positions << {direction: 'left', next_position: next_position_left, input: 3}
        end

        selected = unknown_positions.first || empty_positions.sample
        next_position = selected[:next_position]

        # print_tiles(tiles: tiles, message: "Asking the droid to move #{selected[:direction].upcase} from #{position} to #{next_position}.") if (1..100).to_a.sample == 1
        runner.enter_input(selected[:input])
      elsif runner.status == 'paused'
        if runner.output == 0 # Wall!
          tiles[next_position] = 0
          print_tiles(tiles: tiles, message: "We have hit a wall in #{next_position}. The droid continues stays in #{position}") if (1..10).to_a.sample == 1   
          runner.run
        elsif runner.output == 1 # The droid moved successfully
          tiles[next_position] = 'Droid'
          tiles[position] = 1
          # print_tiles(tiles: tiles, message: "We have moved to #{next_position}. Marking old position #{position} as empty air")
          position = next_position.dup
          runner.run
        elsif runner.output == 2 # Success!
          tiles[next_position] = 2
          print_tiles(tiles: tiles, message: "We have solved the maze!")
          puts tiles.inspect
          break
        end
      end
    end

  end


 



  def print_tiles(tiles: , message: )
    system "clear"
    puts message
    result = (25.downto(-20)).to_a.map do |y|
      line = (-30..25).to_a.map do |x| 
        case tiles[[x,y]]
        when 0
          '█'
        when 1
          ' '
        when 2
          'X'
        when 'Droid'
          'D'
        else
          '.'
        end
      end
      line.join("") if line
    end
    puts result.join("\n") if result
  end


end


include Something
# puts calculate_mouse(File.read('15_input').split(',').map(&:to_i))

# puts calculate(File.read('15_input').split(',').map(&:to_i))

puts calculate_b(File.read('15_input').split(',').map(&:to_i))
