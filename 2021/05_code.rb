lines = File.readlines('05_input')

n = 1000
grid = Array.new(n)
n.times do |row_index|
  grid[row_index] = Array.new(n)
  n.times do |column_index|
    grid[row_index][column_index] = 0
  end
end

## Part 1
# lines.each do |line|
#   start = line.split(" -> ")[0]
#   finish = line.split(" -> ")[1]

#   x1,y1=start.split(',').map(&:to_i)
#   x2,y2=finish.split(',').map(&:to_i)

#   next unless x1 == x2 || y1 == y2

#   y1,y2 = y2,y1 if y1 > y2
#   x1,x2 = x2,x1 if x1 > x2

  # (y1..y2).to_a.each do |y|
  #   (x1..x2).to_a.each do |x|
  #     grid[y][x] += 1
  #   end
  # end

#   # print "\n\n\n\n"
#   # puts "Line: #{line}\n"

# end

# count = 0

# grid.each do |row|
#   row.each do |column|
#     if column > 1
#       count += 1
#     end
#     print column == 0 ? '.' : column
#     print ""
#   end
#   print "\n"
# end


# puts count




# Part 2


lines.each do |line|
  # line = "6,4 -> 2,0"
  puts line
  start = line.split(" -> ")[0]
  finish = line.split(" -> ")[1]

  x1,y1=start.split(',').map(&:to_i)
  x2,y2=finish.split(',').map(&:to_i)




  if x1 == x2 || y1 == y2
    puts "Horizontal or vertical, boring"
    y1,y2 = y2,y1 if y1 > y2
    x1,x2 = x2,x1 if x1 > x2
    (y1..y2).to_a.each do |y|
      (x1..x2).to_a.each do |x|
        grid[y][x] += 1
      end
    end
  else
    x = x1
    y = y1
    loop do
      grid[y][x] += 1
      break if x == x2
      x += x2 > x1 ? 1 : -1
      y += y2 > y1 ? 1 : -1
    end
    puts "45 degree!"
  end


  

end


count = 0

  grid.each do |row|
    row.each do |column|
      if column > 1
        count += 1
      end
      # print column == 0 ? '.' : column
      # print ""
    end
    # print "\n"
  end
  print "\n\n"

print "\n\n"

puts "\n\n#{count}"