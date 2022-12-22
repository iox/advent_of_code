input = File.read('09_example').split("\n")

tail_visits = Hash.new(0) # Key represent x/y positions, value represent amount
tail_visits[[0,0]] = 1 # We have visited the starting point once

tail = {x: 0, y: 0}
head = {x: 0, y: 0}


def move_head(direction, head)
  case direction
  when 'R'
    head[:x] += 1
  when 'L'
    head[:x] -= 1
  when 'U'
    head[:y] -= 1
  when 'D'
    head[:y] += 1
  end
end


def follow_tail(head, tail, tail_visits, is_last = false, number=0)
  # puts "\n  head: #{head.inspect} / tail: #{tail.inspect}"
  moved = false

  dx = head[:x] - tail[:x]
  dy = head[:y] - tail[:y]

  if dx.abs > 1 && dy.abs > 1
    tail[:x] += dx / 2
    tail[:y] += dy / 2
    moved = true
  elsif dx.abs > 1
    tail[:x] += dx / 2
    tail[:y] = head[:y]
    moved = true
  elsif dy.abs > 1
    tail[:y] += dy / 2
    tail[:x] = head[:x]
    moved = true
  end

  if moved
    # puts "   tail #{number} moved to #{tail}  (dy #{dy} dx #{dx})" 
  end

  tail_visits[[tail[:x], tail[:y]]] += 1 if moved && is_last
  return tail
end


def print_debug(head, tails, tail_visits)
  puts "\n"
  (-15..6).to_a.each do |grid_y|
    (-11..14).to_a.each do |grid_x|
      if head[:x] == grid_x && head[:y] == grid_y
        print "H"
        next
      end

      if tail_visits.keys.include?([grid_x, grid_y])
        print "#"
        next
      end

      printed = false
      tails.each_with_index do |tail, i|
        if tail[:x] == grid_x && tail[:y] == grid_y
          print i+1
          printed = true
          break
        end
      end
      next if printed

      if grid_x == 0 && grid_y == 0
        print "s"
        next
      end



      print "."
    end
    print "\n"
  end
  
  print "\n\n\n\n"

end



# print_debug(tail, head)

# input.each do |line|
#   direction = line.split(" ")[0]
#   amount = line.split(" ")[1].to_i

#   amount.times do
#     # puts "\n -- #{direction} --"
#     move_head(direction, head)
#     follow_tail(head, tail, tail_visits, true)
#     # print_debug(head, [tail])
#   end

# end

# puts tail_visits.keys.size
# puts tail_visits.inspect









# Part 2

input = File.read('09_input').split("\n")

tail_visits = Hash.new(0) # Key represent x/y positions, value represent amount
tail_visits[[0,0]] = 1 # We have visited the starting point once

tails = [{x: 0, y: 0}]*9
# puts tails.inspect
head = {x: 0, y: 0}


# input = ["R 4", "U 4"]
# print_debug(head, tails, tail_visits)

puts input.inspect
input.each do |line|

  puts "\n\n\n#{line}"
  direction = line.split(" ")[0]
  amount = line.split(" ")[1].to_i

  amount.times do
    move_head(direction, head)
    # puts "#{direction}   #{head.inspect}"
    previous = head.dup

    tails = tails.map.with_index do |tail, i|
      is_last = (i == tails.size - 1)

      tail = follow_tail(previous.dup, tail.dup, tail_visits, is_last, i+1)
      previous = tail.dup
      tail.dup
    end
    # print_debug(head, tails)

    # puts "Head " + head.inspect
    # puts "Tails " + tails.inspect
  end
  # print_debug(head, tails, tail_visits)


end

puts "\n\n\n" + tail_visits.keys.size.to_s
# puts tail_visits.inspect



