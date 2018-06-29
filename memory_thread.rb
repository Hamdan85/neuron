class MemoryThread
  attr_accessor :id, :argument, :thread, :brain
  def initialize(id, argument, brain)
    @id       = id
    @brain    = brain
    @argument = argument
    @thread   = [argument]
  end

  def add_to_thread(id)
    @thread << Positioner.new(id, brain.cubic_root, brain).to_coordinate
  end
end