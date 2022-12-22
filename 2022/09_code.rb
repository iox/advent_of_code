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


def follow_tail(head, tail, tail_visits, last = false)
  moved = false

  dx = head[:x] - tail[:x]
  dy = head[:y] - tail[:y]

  if dx.abs > 1
    tail[:x] += dx / 2
    tail[:y] = head[:y]
    moved = true
  elsif dy.abs > 1
    tail[:y] += dy / 2
    tail[:x] = head[:x]
    moved = true
  end

  tail_visits[[tail[:x], tail[:y]]] += 1 if moved && last
  return tail
end


def print_debug(head, tails)
  puts "\n\n"
  (-4..4).to_a.each do |grid_y|
    (-10..10).to_a.each do |grid_x|
      if head[:x] == grid_x && head[:y] == grid_y
        print "H"
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

      print "."
    end
    print "\n"
  end
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

input = File.read('09_example2').split("\n")

tail_visits = Hash.new(0) # Key represent x/y positions, value represent amount
tail_visits[[0,0]] = 1 # We have visited the starting point once

tails = [{x: 0, y: 0}]*2
puts tails.inspect
head = {x: 0, y: 0}


input.each do |line|
  direction = line.split(" ")[0]
  amount = line.split(" ")[1].to_i

  amount.times do
    # puts "\n -- #{direction} --"
    move_head(direction, head)
    previous = head

    tails.each.with_index do |tail, i|
      is_last = (i == tails.size - 1)
      tail = follow_tail(previous, tail, tail_visits, is_last)
      previous = tail
      tails[i] = tail
    end
    print_debug(head, tails)
  end

end

puts tail_visits.keys.size
# puts tail_visits.inspect



