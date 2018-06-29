class Positioner
  attr_reader :x, :y, :z, :brain

  def initialize(id, cube_root, brain)
    @id         = id
    @cube_root  = cube_root
    @brain      = brain
    calc_position
  end

  def calc_position
    calc_z
    calc_xy
  end

  def square
    @cube_root ** 2
  end

  def calc_z
    @z = @id / square
  end

  def calc_xy
    plane = @id - (square * z)
    @y = plane / @cube_root
    @x = plane % @cube_root
  end

  def connects_to
    radius      = brain.radius || 20
    neighbors   = []
    arr_x = ((x - radius)..(x + radius)).to_a.reject{ |current_z| current_z > (@cube_root - 1) || current_z < 0 }
    arr_y = ((y - radius)..(y + radius)).to_a.reject{ |current_y| current_y > (@cube_root - 1) || current_y < 0 }
    arr_z = ((z - radius)..(z + radius)).to_a.reject{ |current_x| current_x > (@cube_root - 1) || current_x < 0 }
    arr_z.each do |current_z|
      arr_y.each do |current_y|
        arr_x.each do |current_x|
          id_from_coordinates = id_from_coordinates(current_x, current_y, current_z)
          neighbors << id_from_coordinates unless id_from_coordinates.eql?(@id)
        end
      end
    end
    neighbors
  end

  def id_from_coordinates(zi, yi, xi)
    (square * zi) + (yi * @cube_root) + xi
  end

  def to_coordinate
    [x, y, z]
  end

  def to_neuron
    Neuron.new(@id, @brain, x, y, z, connects_to, start_neuron?, end_neuron?)
  end

  def start_neuron?
    z.zero?
  end

  def end_neuron?
    z == (@cube_root - 1)
  end
end