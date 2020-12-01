#! /usr/bin/env ruby

load 'intcode.rb'

module Something

  def calculate_b(input)
    tiles = calculate(input.dup)
    input[0] = 2
    runner = Intcode.new(memory: input)
    runner.run

    lines = [
      "A,B,C,C", #main routing
      "L,10,L,6", # function a
      "R,10,R,6,R,8,R,8", # function b
      "L,6,R,8,L,10", # function c
    ]

    raise "ERROR TOO MANY CHARS" if lines.any?{|line| line.size > 20}

    puts "lines"
    puts lines.inspect

    lines = lines.map{|line| line.split('').map(&:ord) }
    


    puts "lines ASCII"
    puts lines.inspect

    instructions = []

    for line in lines
      for ins in line
        instructions << ins
      end
      instructions << 10 # newline
    end

    # instructions << 110 # "n", disable video feed
    instructions << 121 # "n", disable video feed
    instructions << 10 # newline


    puts "instructions: #{instructions}"
    

    instruction_index = 0



    loop do
      if runner.status == 'finished'
        puts "FINISHED"
        puts runner.output
        break
      end

      if runner.status == 'paused'
        print runner.output.chr
        runner.run
      end

      if runner.status == 'waiting_for_input'
        puts "ENTERING INPUT #{instructions[instruction_index].chr.inspect}"
        runner.enter_input(instructions[instruction_index])
        instruction_index += 1
      end
    end


    return "--"

  end



  

  def calculate(input)
    runner = Intcode.new(memory: input)
    runner.run

    camera_view = []
    loop do
      if runner.status == 'paused'
        camera_view << runner.output
        runner.run
      end

      if runner.status == 'finished'
        break
      end
    end

    # puts camera_view.map(&:chr).join

    # puts "\n\n\n----------------\n\n\n"

    # 53 tiles width, 53/55 tiles high
    x = 0
    y = 0
    tiles = {}
    camera_view.map(&:chr).each do |char|
      if char == "\n"
        y += 1
        x = 0
      else
        tiles[[x,y]] = char
        x += 1
      end
    end

    print_tiles(tiles: tiles)




    # TODO: Find the intersections (a # with # all around)

    # Multiply their coordinates.
    sum = 0
    tiles.each do |pos, value|
      up = [pos[0], pos[1]+1]
      left = [pos[0]-1, pos[1]]
      right = [pos[0]+1, pos[1]]
      up = [pos[0], pos[1]-1]
      if [up,left,right,up,pos].all?{|position| tiles[position] == '#'}
        sum += pos[0]*pos[1]
      end
    end

    puts sum

    tiles


    


    # Sum them
  end




  def print_tiles(tiles: , message: '')
    puts message
    result = (0..53).to_a.map do |y|
      line = (0..53).to_a.map do |x| 
        tiles[[x,y]]
      end
      line.join("") if line
    end
    puts result.join("\n") if result
  end


end


include Something

# calculate(File.read('17_input').split(',').map(&:to_i))
puts calculate_b(File.read('17_input').split(',').map(&:to_i))