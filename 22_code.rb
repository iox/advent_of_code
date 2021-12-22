# input = <<HERE
# on x=10..12,y=10..12,z=10..12
# on x=11..13,y=11..13,z=11..13
# off x=9..11,y=9..11,z=9..11
# on x=10..10,y=10..10,z=10..10
# HERE

input = <<HERE
on x=-20..26,y=-36..17,z=-47..7
on x=-20..33,y=-21..23,z=-26..28
on x=-22..28,y=-29..23,z=-38..16
on x=-46..7,y=-6..46,z=-50..-1
on x=-49..1,y=-3..46,z=-24..28
on x=2..47,y=-22..22,z=-23..27
on x=-27..23,y=-28..26,z=-21..29
on x=-39..5,y=-6..47,z=-3..44
on x=-30..21,y=-8..43,z=-13..34
on x=-22..26,y=-27..20,z=-29..19
off x=-48..-32,y=26..41,z=-47..-37
on x=-12..35,y=6..50,z=-50..-2
off x=-48..-32,y=-32..-16,z=-15..-5
on x=-18..26,y=-33..15,z=-7..46
off x=-40..-22,y=-38..-28,z=23..41
on x=-16..35,y=-41..10,z=-47..6
off x=-32..-23,y=11..30,z=-14..3
on x=-49..-5,y=-3..45,z=-29..18
off x=18..30,y=-20..-8,z=-3..13
on x=-41..9,y=-7..43,z=-33..15
on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
on x=967..23432,y=45373..81175,z=27513..53682
HERE

input = File.read('22_input')



class Cuboid
  attr_accessor :x_min, :x_max, :y_min, :y_max, :z_min, :z_max, :polarity

  def initialize(x_min,x_max,y_min,y_max,z_min,z_max, polarity=1)
    @x_min = x_min
    @x_max = x_max
    @y_min = y_min
    @y_max = y_max
    @z_min = z_min
    @z_max = z_max
  
    @polarity = polarity
  end

  def x_length
    (x_max - x_min)+1
  end

  def y_length
    (y_max - y_min)+1
  end

  def z_length
    (z_max - z_min)+1
  end

  def volume
    x_length * y_length * z_length * polarity
  end


  def substract(b_x_min,b_x_max,b_y_min,b_y_max,b_z_min,b_z_max)
    ix = ([x_min, b_x_min].max)..([x_max, b_x_max].min)
    return if ix.begin > ix.end

    iy = ([y_min, b_y_min].max)..([y_max, b_y_max].min)
    return if iy.begin > iy.end

    iz = ([z_min, b_z_min].max)..([z_max, b_z_max].min)
    return if iz.begin > iz.end

    Cuboid.new(ix.begin,ix.end,iy.begin,iy.end,iz.begin,iz.end,polarity*-1)
  end
end


cuboids = []
instructions = input.split("\n")
instructions.each do |instruction|
  regex = /x=(-?\d{1,})..(-?\d{1,}),y=(-?\d{1,})..(-?\d{1,}),z=(-?\d{1,})..(-?\d{1,})/
  x_min,x_max,y_min,y_max,z_min,z_max = instruction.match(regex).captures.map(&:to_i)

  # part1
  # next if x_min < -50 || x_max > 50


  new_cuboids = []
  cuboids.each do |cuboid| 
    inverse_overlap_cuboid = cuboid.substract(x_min.to_i,x_max,y_min,y_max,z_min,z_max)
    if inverse_overlap_cuboid
      # puts "Adding one inverse cuboid"
      new_cuboids << inverse_overlap_cuboid
    else
      # puts "NO OVERLAP"
    end
  end

  if instruction.include?("on")
    cuboids << Cuboid.new(x_min,x_max,y_min,y_max,z_min,z_max,1)
  end

  cuboids += new_cuboids
end

puts cuboids.sum(&:volume)