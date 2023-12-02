heightmap = File.readlines('09_input').map{|l| l.chomp.chars.map(&:to_i)}

risk_sum = 0
heightmap.each_with_index do |row, y|
  row.each_with_index do |value, x|
    # print value
    up = heightmap[y][x+1]
    down = heightmap[y][x-1]
    left = heightmap[y-1][x]
    right = heightmap[y+1] ? heightmap[y+1][x] : nil
    if [up,down,left,right].compact.all?{|v| v > value}
      # print "\033[31m#{value}\033[0m"
      risk_sum += 1 + value
    else
      # print value
    end
  end
  # print "\n"
end

puts risk_sum





basins = []
heightmap.each_with_index do |row, y|
  row.each_with_index do |value, x|
    # print value
    up = heightmap[y][x+1]
    down = heightmap[y][x-1]
    left = heightmap[y-1][x]
    right = heightmap[y+1] ? heightmap[y+1][x] : nil
    if [up,down,left,right].compact.all?{|v| v > value}
      basins << [[y,x]]
    end
  end
end




basins.each do |basin_points|
  queue = basin_points.dup

  loop do
    break if queue.size == 0

    y,x = queue.shift
    value = heightmap[y][x]
    
    right = [y,x+1]
    left = [y,x-1]
    up = [y-1,x]
    down = [y+1, x]

    [up,down,left,right].each do |y, x|
      next_value = heightmap[y] ? heightmap[y][x] : nil
      next if y < 0 || x < 0
      next if next_value.nil?
      next if next_value == 9
      next if next_value <= value
      next if basin_points.include?([y, x])

      basin_points << [y,x]
      queue << [y,x]
    end

  end



  # Debug print
  # heightmap.each_with_index do |row, y|
  #   row.each_with_index do |value, x|
  #     if basin_points.include?([y,x])
  #       print "\033[31m#{heightmap[y][x]}\033[0m"
  #     else
  #       print heightmap[y][x]
  #     end
  #   end
  #   print "\n"
  # end
  # print "\n\n"
end

# puts basins.first.inspect
puts basins.map(&:size).max(3).reduce(:*)

# puts basin_sizes.inspect#reduce(&:*)