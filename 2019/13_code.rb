#! /usr/bin/env ruby

load 'intcode.rb'

module Something
  def calculate(input)
    runner = Intcode.new(memory: input)
    runner.run

    x = nil
    y = nil

    tiles = {}


    loop do
      if runner.status == 'waiting_for_input'
        raise "NOT IMPLEMENTED"
      elsif runner.status == 'paused'
        if x.nil?
          x = runner.output
          
        elsif y.nil?
          y = runner.output
        else
          tiles[[x,y]] = runner.output
          x = nil
          y = nil
        end
        runner.run

      elsif runner.status == 'finished'
        break
      else
        raise "WTF #{runner.status}"
      end
    end

    puts tiles.values.select{|v| v == 2}
    tiles.values.select{|v| v == 2}.size
  end


  def calculate_b(input)
    input[0] = 2
    runner = Intcode.new(memory: input)
    runner.run

    x = nil
    y = nil

    tiles = {}
    score = 0
    max_score = 0
    memories = []
    last_good_memory = nil

    loop do
      if runner.status == 'waiting_for_input'
        memories.push({tiles: tiles.dup, memory: runner.memory.dup, pointer: runner.pointer.dup, status: runner.status.dup, score: score})
        print_tiles(tiles, score, max_score)
        # begin
        #   system("stty raw -echo")
        #   str = STDIN.getc
        # ensure
        #   system("stty -raw echo")
        # end
        # p str.chr
        # if str.chr == 'a'
        #   instruction = -1
        # elsif str.chr == 's'
        #   instruction = 0
        # elsif str.chr == 'd'
        #   instruction = 1
        # elsif str.chr == 'b'
        #   3.times{memories.pop}
        #   last_good_memory = memories.last.dup
        #   runner.memory = last_good_memory[:memory]
        #   runner.pointer = last_good_memory[:pointer]
        #   runner.status = last_good_memory[:status]
        #   tiles = last_good_memory[:tiles]
        #   score = last_good_memory[:score]
        #   print_tiles(tiles, score, max_score)
        #   next
        # else
        #   puts "NOT SUPPORTED, USE asd"
        #   instruction = 0
        # end

        ball_x = tiles.find{|k,v| v==4}[0][0].dup
        paddle_x = tiles.find{|k,v| v==3}[0][0].dup
        # sleep 0.05
        if ball_x == paddle_x
          instruction = 0
        elsif ball_x > paddle_x
          instruction = 1
        else
          instruction = -1
        end

        runner.enter_input(instruction)
      elsif runner.status == 'paused'
        if x.nil?
          x = runner.output
          
        elsif y.nil?
          y = runner.output
        else
          if x == -1 && y == 0
            score = runner.output
            max_score = runner.output if runner.output > max_score
          else
            tiles[[x,y]] = runner.output
          end
          x = nil
          y = nil
          print_tiles(tiles, score, max_score)
        end
        runner.run

      elsif runner.status == 'finished'
        # raise "STOP"
        
        if memories.size < 55
          (memories.size-2).times{memories.pop}
        else
          (5..50).to_a.sample.times{memories.pop}
        end
        last_good_memory = memories.last.dup
        runner.memory = last_good_memory[:memory]
        runner.pointer = last_good_memory[:pointer]
        runner.status = last_good_memory[:status]
        tiles = last_good_memory[:tiles]
        score = last_good_memory[:score]
        print_tiles(tiles, score, max_score)
      else
        raise "WTF #{runner.status}"
      end

      # The game ends when all the blocks are destroyed
      remaining_blocks = tiles.values.select{|v| v == 2}.size
      
      # break if remaining_blocks == 0 && score > 0
    end

    score
  end

  def print_tiles(tiles, score, max_score)
    system "clear"
    remaining_blocks = tiles.values.select{|v| v == 2}.size
    puts "remaining_blocks: #{remaining_blocks}, score: #{score}, max_score: #{max_score}"
    result = (0..25).to_a.map do |y|
      line = (0..42).to_a.map do |x| 
        case tiles[[x,y]]
        when 0
          ' '
        when 1
          '█'
        when 2
          '█'
        when 3
          '█'
        when 4
          '█'
        else
          ' '
        end
      end
      line.join("") if line
    end
    puts result.join("\n") if result


  end



end


# if !ARGV.include?("run")
#   require 'test/unit'

#   class SomethingTest < Test::Unit::TestCase
#     include Something
#     def test_calculate
#     end
#   end

# else
  include Something
  # puts calculate(File.read('13_input').split(',').map(&:to_i))

  result = calculate_b(File.read('13_input').split(',').map(&:to_i))
  puts result
  
# end
