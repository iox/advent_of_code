class Moon

  attr_accessor :position, :velocity

  def initialize(initial_position:, rjust:)
    @position = initial_position
    @velocity = {x: 0, y:0, z: 0}
    @rjust = rjust
  end

  def apply_gravity_x(other:, amount:)
    amount = 1 if amount == 0
    if self.posx != other.posx
      self.velx += self.posx > other.posx ? (amount*-1) : amount
    end
  end

  def apply_gravity_y(other:, amount:)
    amount = 1 if amount == 0
    if self.posy != other.posy
      self.vely += self.posy > other.posy ? (amount*-1) : amount
    end
  end

  def apply_gravity_z(other:, amount:)
    amount = 1 if amount == 0
    if self.posz != other.posz
      self.velz += self.posz > other.posz ? (amount*-1) : amount
    end
  end

  def apply_velocity
    self.posx += velx
    self.posy += vely
    self.posz += velz
  end

  def status
    "pos=<x=#{posx.to_s.rjust(@rjust)}, y=#{posy.to_s.rjust(@rjust)}, z=#{posz.to_s.rjust(@rjust)}>, vel=<x=#{velx.to_s.rjust(@rjust)}, y=#{vely.to_s.rjust(@rjust)}, z=#{velz.to_s.rjust(@rjust)}>"
  end

  def energy
    (posx.abs + posy.abs + posz.abs) * (velx.abs + vely.abs + velz.abs)
  end


  



  def posx() @position[:x] end
  def posy() @position[:y] end
  def posz() @position[:z] end
  def velx() @velocity[:x] end
  def vely() @velocity[:y] end
  def velz() @velocity[:z] end

  def posx=(value) @position[:x]=value end
  def posy=(value) @position[:y]=value end
  def posz=(value) @position[:z]=value end
  def velx=(value) @velocity[:x]=value end
  def vely=(value) @velocity[:y]=value end
  def velz=(value) @velocity[:z]=value end
end
