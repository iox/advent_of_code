

# 3 axis, both scanners have the same x,y,z order and direction
input = <<HERE
--- scanner 0 ---
0,2,0
4,1,0
3,3,0

--- scanner 1 ---
-1,-1,1
-5,0,1
-2,1,1
HERE


# 3 axis, x and y are switched in scanner 1
input = <<HERE
--- scanner 0 ---
0,2,0
4,1,0
3,3,0

--- scanner 1 ---
-1,-1,1
0,-5,1
1,-2,1
HERE




input = File.read('19_input_example')
input = File.read('19_input')



def roll(scanner)
  scanner.map do |b|
    x,y,z = b
    # z becomes y, y becomes -z
    [x, z, y*-1]
  end
end

def turn_cw(scanner)
  scanner.map do |b|
    x,y,z = b
    # z becomes x, x becomes -z
    [z, y, x*-1]
  end
end

def turn_ccw(scanner)
  scanner.map do |b|
    x,y,z = b
    # x becomes z, z becomes -x
    [z*-1, y, x]
  end
end


# Find 24 different orientations for the scanner input.
# Orientation logic thanks to Blanca's cube toy and https://stackoverflow.com/a/58471362
def find_orientations(scanner)
  orientations = []
  6.times.with_index do |roll_index|
    scanner = roll(scanner)
    orientations << scanner
    3.times do
      if roll_index % 2 == 0
        scanner = turn_cw(scanner)
      else
        scanner = turn_ccw(scanner)
      end
      orientations << scanner
    end
  end
  orientations
end








# input = File.read('19_input_example')
scanners = input.split("\n\n").map{|scanner_input| scanner_input.split("\n").select{|l| l.include?(',')}.map{|l|l.split(",").map(&:to_i)}}


# scanners.each_with_index do |scanner, index|
#   puts "\nScanner #{index}:"
#   puts scanner.inspect
# end





def find_deltas(s0, s1)
  possible_deltas = []
  matching_beacons = []

  s0_all_x = s0.map{|p|p[0]}
  s0_all_y = s0.map{|p|p[1]}
  s0_all_z = s0.map{|p|p[2]}

  s0.each do |s0point|
    s0x,s0y,s0z = s0point
    s1.each do |s1point|
      s1x,s1y,s1z = s1point
      
      dx = s1x - s0x
      dy = s1y - s0y
      dz = s1z - s0z
      possible_deltas << [dx, dy, dz]
    end
  end

  correct_delta = possible_deltas.find do |delta|
    dx,dy,dz = delta

    matching_beacons = s1.select do |s1point|
      s1x,s1y,s1z = s1point
      if s0_all_x.include?(s1x - dx) && s0_all_y.include?(s1y - dy) && s0_all_z.include?(s1z - dz)
        next true
      end
    end

    if matching_beacons.size >= 12
      next true
    end
  end

  if correct_delta
    return correct_delta, matching_beacons
  else
    return nil,nil
  end
end


matching_beacons_from_zero = []

# When we start, the only oriented scanner is 0
oriented_scanners = [{
  delta_from_zero: [0,0,0],
  data: scanners[0],
  data_from_zero: scanners[0]
}]
misoriented_scanners = scanners.drop(1)

loop do
  puts "\n\n\n\n\n>>> There are #{oriented_scanners.size} oriented and #{misoriented_scanners.size} misoriented <<<"
  break if misoriented_scanners.size == 0

  oriented_scanner = oriented_scanners.sample

  oriented_delta_from_zero = oriented_scanner[:delta_from_zero]
  oriented_data = oriented_scanner[:data]
  
  misoriented_scanners.each_with_index do |misoriented, misoriented_index|
    find_orientations(misoriented).each_with_index do |orientation, index|
      delta, matching_beacons = find_deltas(oriented_data, orientation)
      if delta      
        dx,dy,dz = delta
        delta_from_zero = [
          oriented_delta_from_zero[0] - dx,
          oriented_delta_from_zero[1] - dy,
          oriented_delta_from_zero[2] - dz,
        ]




        # Add to the global list of matching beacons from zero's perspective
        temp = matching_beacons.map do |b|
          x,y,z = b
          [x+delta_from_zero[0],y+delta_from_zero[1],z+delta_from_zero[2]]
        end
        matching_beacons_from_zero += temp


        # Convert the data into the 0's frame of reference
        data_from_zero = orientation.map do |point|
          x,y,z = point
          [x+delta_from_zero[0],y+delta_from_zero[1],z+delta_from_zero[2]]
        end




        # Move from "misoriented" to "oriented"
        misoriented_scanners.delete(misoriented)
        oriented_scanners << {
          data: orientation,
          delta_from_zero: delta_from_zero,
          data_from_zero: data_from_zero
        }




        # PRINT/DEBUG
        puts "\n\n\nFound a working orientation in loop #{index} with misoriented_index #{misoriented_index}, stopping"
        # puts orientation.inspect
        puts "Delta: #{delta.inspect}"
        puts "Delta from 0: #{delta_from_zero.inspect}"
        # puts "Printing matching beacons from the perspective of 0"
        # temp.each do |b|
        #   puts b.join(",")
        # end

        puts "\n\ndata_from_zero: "
        data_from_zero.each do |d|

          print d.join(",")
          if matching_beacons_from_zero.include?(d)
            print "  ***"
          end
          print "\n"
        end
        puts "\n\n"


        break
      end
    end
  end
end


# find_orientations(scanners[1]).each_with_index do |orientation, index|
#   delta, matching_beacons = find_deltas(scanners[0], orientation)
#   if delta
#     scanners[1] = orientation # Fix the orientation for subsequent loops

#     dx,dy,dz = delta

#     delta_from_zero[0] -= dx
#     delta_from_zero[1] -= dy
#     delta_from_zero[2] -= dz

#     puts "\n\n\nFound a working orientation in loop #{index}, stopping"
#     puts orientation.inspect
#     puts "Delta: #{delta.inspect}"
#     puts "Delta from 0: #{delta_from_zero.inspect}"

#     temp = matching_beacons.map do |b|
#       x,y,z = b
#       [x+delta_from_zero[0],y+delta_from_zero[1],z+delta_from_zero[2]]
#     end
#     matching_beacons_from_zero += temp
#     puts "Printing matching beacons from the perspective of 0"
#     temp.each do |b|
#       puts b.join(",")
#     end
#     break
#   end
# end





# find_orientations(scanners[1]).each_with_index do |orientation, index|
#   delta, matching_beacons = find_deltas(scanners[0], orientation)
#   if delta
#     scanners[1] = orientation # Fix the orientation for subsequent loops

#     dx,dy,dz = delta

#     delta_from_zero[0] -= dx
#     delta_from_zero[1] -= dy
#     delta_from_zero[2] -= dz

#     puts "\n\n\nFound a working orientation in loop #{index}, stopping"
#     puts orientation.inspect
#     puts "Delta: #{delta.inspect}"
#     puts "Delta from 0: #{delta_from_zero.inspect}"

#     temp = matching_beacons.map do |b|
#       x,y,z = b
#       [x+delta_from_zero[0],y+delta_from_zero[1],z+delta_from_zero[2]]
#     end
#     matching_beacons_from_zero += temp
#     puts "Printing matching beacons from the perspective of 0"
#     temp.each do |b|
#       puts b.join(",")
#     end
#     break
#   end
# end







# find_orientations(scanners[4]).each_with_index do |orientation, index|
#   delta, matching_beacons = find_deltas(scanners[1], orientation)
#   if delta
#     dx,dy,dz = delta

#     delta_from_zero[0] -= dx
#     delta_from_zero[1] -= dy
#     delta_from_zero[2] -= dz

#     puts "\n\n\nFound a working orientation in loop #{index}, stopping"
#     puts orientation.inspect
#     puts "Delta: #{delta.inspect}"
#     puts "Delta from 0: #{delta_from_zero.inspect}"

#     temp = matching_beacons.map do |b|
#       x,y,z = b
#       [x+delta_from_zero[0],y+delta_from_zero[1],z+delta_from_zero[2]]
#     end
#     matching_beacons_from_zero += temp
#     puts "Printing matching beacons from the perspective of 0"
#     temp.each do |b|
#       puts b.join(",")
#     end
#     break
#   end
# end

matching_beacons_from_zero.uniq!.sort


matching_beacons_from_zero.each do |mb|
  puts mb.inspect
end

puts "matching_beacons_from_zero.size: #{matching_beacons_from_zero.size}"







puts oriented_scanners.map{|s| s[:data_from_zero]}.reduce(:+).uniq.size
