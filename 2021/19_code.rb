

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


# Part 1
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


matching_beacons_from_zero.uniq!.sort
matching_beacons_from_zero.each do |mb|
  puts mb.inspect
end

puts "matching_beacons_from_zero.size: #{matching_beacons_from_zero.size}"







puts oriented_scanners.map{|s| s[:data_from_zero]}.reduce(:+).uniq.size

scanner_positions = oriented_scanners.map{|s| s[:delta_from_zero]}
puts scanner_positions.inspect



# Hardcoding them here so I don't have to do the slow part 1 again
# scanner_positions = [[0, 0, 0], [-70, 28, -1272], [9, 1216, -25], [14, 1370, 1125], [1275, 1293, -40], [1148, 1288, 1221], [1312, 2431, -74], [2388, 1292, -161], [2468, 1268, 1037], [107, 2503, 1043], [-1192, 1274, 1183], [3559, 1311, 1162], [6, 130, -2570], [18, -1061, -1242], [1254, 47, -2555], [-1183, 27, -2414], [53, 1240, -2471], [51, -1172, -2389], [-1201, -1054, -2387], [-1181, 12, -3643], [-1145, -1019, -1316], [-1177, -2373, -2403], [3697, 1342, -106], [2361, 63, -153], [2411, -1056, -3], [83, -2268, -2440], [69, -2403, -1371], [-1226, 25, 1218], [-1246, 1273, 2324], [2378, -1045, 1223], [2377, -2303, 6], [-2475, 53, 1039], [-2458, 150, -130], [-2404, -1074, -96], [2401, -3418, -16]]


distances = scanner_positions.combination(2).to_a.map do |(a,b)|
  (a[0]-b[0]).abs + (a[1]-b[1]).abs + (a[2]-b[2]).abs
end

puts distances.max
