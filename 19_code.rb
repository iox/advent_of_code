#! /usr/bin/env ruby

load 'intcode.rb'

module Something

  def calculate(input)
    tiles = {}
    (0..49).to_a.each do |y|
      (0..49).to_a.each do |x| 
        runner = Intcode.new(memory: input)
        runner.run
        puts "Entering X #{x}"
        runner.enter_input(x)
        puts "Entering Y #{y}"
        runner.enter_input(y)
        puts "Output: #{runner.output}"
        tiles[[x,y]] = runner.output
        runner.run
      end
    end
    print_tiles(tiles: tiles)
  end


                #   # print_tiles(tiles: tiles)
                #   loop do
                #     puts "runner.status #{runner.status}"
                #     sleep 0.1


                #     if runner.status == 'waiting_for_input'
                #       if x.nil?
                #         puts "Entering Y #{y}"
                #         runner.enter_input(y)
                #       else
                #         puts "Entering X #{x}"
                #         runner.enter_input(x)
                #         x = nil
                #       end
                #       next
                #     end

                #     if runner.status == 'paused'
                #       tiles[[x,y]] = runner.output
                #       puts "OUTPUT: #{runner.output}"
                #       runner.run
                #       break
                #     end

                #     if runner.status == 'finished'
                #       exit
                #       break
                #     end

                    
                #   end
                # end



  def print_tiles(tiles: , message: '')
    system "clear"
    puts message
    result = (0..50).to_a.map do |y|
      line = (0..50).to_a.map do |x| 
        case tiles[[x,y]]
        when 0
          '.'
        when 1
          '#'
        when nil
          ' '
        else
          '?'
        end
      end
      line.join("") if line
    end
    puts result.join("\n") if result
  end


end


include Something

puts calculate(File.read('19_input').split(',').map(&:to_i))
