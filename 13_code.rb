data = File.read('13_input')
dots,folds = data.split("\n\n")

dots = dots.split("\n").map{|d| d.split(",").map(&:to_i).reverse}
folds = folds.split("\n").map do |f|
  axis, value = f.split(" ")[2].split("=")
  {axis: axis, value: value.to_i}
end

puts folds.inspect


# puts dots.inspect
# puts fold_y.inspect
# puts fold_x.inspect


# puts "\n\n"
# 15.times do |y|
#   11.times do |x|
#     if fold_y == y
#       print "-"
#       next
#     end
#     print dots.include?([y,x]) ? "#" : "."
#   end
#   print "\n"
# end

# puts "\n\n"



folds.each do |fold|
  if fold[:axis] == "y"
    dots.each do |dot|
      y,x = dot
      if y > fold[:value]
        distance_to_fold = y-fold[:value]
        new_y = fold[:value] - distance_to_fold
        new_dot = [new_y,x]
        dots << new_dot
      end
    end
    dots.select!{|d| d[0] < fold[:value]}.uniq!

  elsif fold[:axis] == "x"
    dots.each do |dot|
      y,x = dot
      if x > fold[:value]
        distance_to_fold = x-fold[:value]
        new_x = fold[:value] - distance_to_fold
        new_dot = [y,new_x]
        dots << new_dot
      end
    end
    dots.select!{|d| d[1] < fold[:value]}.uniq!
  end
end

# puts dots.inspect

puts "\n\n"
10.times do |y|
  100.times do |x|
    print dots.include?([y,x]) ? "#" : "."
  end
  print "\n"
end

puts dots.size


# puts dots.size