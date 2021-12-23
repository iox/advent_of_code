require 'io/console'

@players = [
  [2,3,"D",1000],
  [3,3,"D",1000],
  [4,3,"D",1000],
  [5,3,"D",1000],
  [2,5,"C",100],
  [3,5,"C",100],
  [4,5,"C",100],
  [5,5,"C",100],
  [2,7,"A",1],
  [3,7,"A",1],
  [4,7,"B",10],
  [5,7,"B",10],
  [2,9,"B",10],
  [3,9,"B",10],
  [4,9,"A",1],
  [5,9,"A",1]
]



@current_player = 0




def render
  system("clear")
  puts "Energy: #{@energy}"
  puts "Player #{@current_player+1}/#{@players.size}"
  (0..6).to_a.each_with_index do |y|
    (0..12).to_a.each_with_index do |x|
      printed = false
      @players.each_with_index do |player, player_index|
        if player[0] == y && player[1] == x
          if @current_player == player_index
            print "\033[33;7m#{player[2]}\033[0m"
          else
            print player[2]
          end
          printed = true
        end
      end
      if !printed
        if x == 0 || y == 0 || x == 12 || (y > 1 && [1,2,4,6,8,10,11].include?(x)) || y > 5
          print "□"
        else
          print "."
        end
      end
    end
    print "\n"
  end
end
  
@energy = 0

loop do
  render
  option = STDIN.getch
  if option == "q"
    break
  elsif option == "w"
    @players[@current_player][0] -= 1
    @energy += @players[@current_player][3]
  elsif option == "a"
    @players[@current_player][1] -= 1
    @energy += @players[@current_player][3]
  elsif option == "s"
    @players[@current_player][0] += 1
    @energy += @players[@current_player][3]
  elsif option == "d"
    @players[@current_player][1] += 1
    @energy += @players[@current_player][3]
  elsif option == "f"
    @current_player -= 1
  elsif option == "g"
    @current_player += 1
  end

end



# initial_map = {
#   hallway: [nil]*11,
#   rooms: [
#     [:B, :A],
#     [:C, :D],
#     [:B, :C],
#     [:D, :A]
#   ]
# }

# COSTS = {
#   :A => 1,
#   :B => 10,
#   :C => 100,
#   :D => 1000
# }


# # I think I need a representation of the map, with all the positions of each element
# # Then I can have a queue with all possible movements that can happen


# def calculate(map, energy)
#   render(map)

#   # Check if the map is correct and stop
#   if is_correct?(map)
#     @min_energy = energy if @min_energy < energy
#     return
#   end

#   # Now, basically I need to through each of the positions and calculate the possibilities which are probably endless.... crazy stuff
#   # Let's move the first guy to the hallway left (takes 2 energy)
#   if map[:rooms][0][0] && map[:hallway][1].nil?
#     new_map = deep_copy(map)
#     new_energy = energy.dup
#     new_energy += COSTS[map[:rooms][0][0]] * 2
#     new_map[:hallway][1] = new_map[:rooms][0][0]
#     new_map[:rooms][0][0] = nil
#     @queue << [new_map, new_energy]
#   end


#   # Let's move the first guy to the hallway right (takes 2 energy)
#   if map[:rooms][0][0] && map[:hallway][3].nil?
#     new_map = deep_copy(map)
#     new_energy = energy.dup
#     new_energy += COSTS[map[:rooms][0][0]] * 2
#     new_map[:hallway][3] = new_map[:rooms][0][0]
#     new_map[:rooms][0][0] = nil
#     @queue << [new_map, new_energy]
#   end




#   # Repeat with the second row in the rooms

#   return nil
# end


# def render(map)
#   puts map.inspect
# end

# def deep_copy(o)
#   Marshal.load(Marshal.dump(o))
# end

# def is_correct?(map)
#   map[:rooms][0] == [:A, :A] && map[:rooms][1] == [:B, :B] && map[:rooms][2] == [:C, :C] && map[:rooms][3] == [:D, :D]
# end



# @min_energy = Float::INFINITY
# @queue = [[initial_map, 0]]

# loop do
#   break if @queue.size == 0
#   map,energy = @queue.shift

#   calculate(map, energy)
# end

# puts @min_energy