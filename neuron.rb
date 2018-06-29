require './memory_thread'

class Neuron
  attr_accessor :id, :x, :y, :z, :brain, :memories, :start_neuron, :end_neuron

  def initialize(id, brain, x, y, z, neighbors, start_neuron = false, end_neuron = false)
    @id               = id
    @x                = x
    @y                = y
    @z                = z
    @brain            = brain
    @neighbors        = neighbors
    @memories         = Hash.recursive
    @start_neuron     = start_neuron
    @end_neuron       = end_neuron
  end

  def inspect
    "<Neuron::#{id} memories=#{@memories}>"
  end

  def process_and_forward(sender, memory_thread_id = nil)
    # Adds a new possible path
    @memories[sender][@neighbors.reject { |neuron| neuron.eql?(sender) || neuron.eql?(id) }.sample] = 0.01
    # Selects weighted random path
    receiver = @memories[sender].max_by {|_, weight| rand ** (1.0 / (weight) )}.first
    @memories[sender][receiver] += 1

    activate_next_neuron(id, receiver, memory_thread_id)
  end


  private

  def activate_next_neuron(sender, receiver, thread_id = nil)
    brain.touch_interaction
    if end_neuron
      # p id.to_s.chars.map(&:to_i).inject(:+).chr unless id.to_s.chars.map(&:to_i).inject(:+) > 255
    else
      # Creates or updates memory thread
      if thread_id.nil?
        thread_id = new_memory_thread
      else
        brain.memory_threads.find { |mt| mt.id.eql?(thread_id) }.add_to_thread(receiver)
      end

      Thread.new do
        brain.neurons.find{ |neuron| neuron.id.eql?(receiver) }.process_and_forward(sender, thread_id)
      end
    end
  end

  def new_memory_thread
    thread = MemoryThread.new(brain.new_memory_thread_id, Positioner.new(id, brain.cubic_root, brain).to_coordinate, brain)
    brain.memory_threads << thread
    thread.id
  end
end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end