#target area: x=20..30, y=-10..-5
target_area_x=20..30
target_area_y=5..10

# target area: x=144..178, y=-100..-76
target_area_x=144..178
target_area_y=76..100



# It either returns nil or the highest y position reached
def simulate(target_area_y, target_area_x, initial_speed_y, initial_speed_x)
  x = 0
  y = 0

  # positions = []
  hits = []

  speed_y = initial_speed_y.dup
  speed_x = initial_speed_x.dup
  
  max_y = 0

  500.times do
    if y > target_area_y.max
      break
    end
    y += speed_y
    x += speed_x
    speed_y += 1
    speed_x -= 1 if speed_x > 0
    speed_x += 1 if speed_x < 0
    max_y = y if max_y > y
    # positions << [y,x]
    if target_area_y.member?(y) && target_area_x.member?(x)
      return max_y
    end
  end





  # debug = true


  # if debug

  #   (-100..50).to_a.each do |grid_y|
  #     (0..300).to_a.each do |grid_x|
  #       if grid_y == 0 && grid_x == 0
  #         print "\33[33mS\033[0m" if debug
  #       elsif positions.include?([grid_y,grid_x]) && target_area_y.member?(grid_y) && target_area_x.member?(grid_x)
  #         hits << [grid_y,grid_x]
  #         print "\033[33mX\033[0m"if debug
  #         puts "\n\n\n" if debug
  #         return grid_y
  #       elsif positions.include?([grid_y,grid_x])
  #         print "\033[32m#\033[0m" if debug
  #       elsif target_area_y.member?(grid_y) && target_area_x.member?(grid_x)
  #         print "T" if debug
  #       else
  #         print "." if debug
  #       end
  #     end
  #     print "\n" if debug
  #   end
  # end

  return nil
end


result = simulate(target_area_y, target_area_x, -4950, 6)
# puts result.inspect

count = 0
(-100..500).to_a.each do |speed_y|
  puts "Simulating speed y #{speed_y}, testing all speed_x values now"
  (0..500).to_a.each do |speed_x|
    result = simulate(target_area_y, target_area_x, speed_y, speed_x)
    if result
      puts "#{count} FOUND HIT with speed y #{speed_y} and speed_x #{speed_x} we reach max_y #{result}"
      count += 1
    end
  end
end
puts count 