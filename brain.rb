require './positioner'
require './neuron'
require 'ap'
require 'csv'

class Brain
  attr_accessor :neurons, :interactions, :memory_threads, :cubic_root

  MOMENTUM_POINT = 1000000

  def initialize(cubic_root)
    @interactions = 0
    @neurons = []
    @memory_threads = []
    @cubic_root = cubic_root
    (cubic_root ** 3).times do |i|
      neuron = Positioner.new(i, cubic_root, self).to_neuron
      @neurons << neuron
    end
  end

  def interactions
    if @interactions > MOMENTUM_POINT
      0.0
    else
      (MOMENTUM_POINT - @interactions).to_f
    end
  end

  def touch_interaction
    self.interactions += 1
  end

  def new_memory_thread_id
    if memory_threads.empty?
      0
    else
      memory_threads.last.id + 1
    end
  end

  # Stabilishes the neigbor for each neuron
  def radius
    radius = (@cubic_root.to_f * 0.1).to_i
    radius.zero? ? 1 : radius
  end

  def inspect
    "<Brain::#{object_id} n_of_neurons=#{@neurons.size}>"
  end

  def print_memory
    neurons.map{|u| u.memories }
  end

  def memory_to_csv
    CSV.open("memory_map.csv", "wb") do |csv|
      csv << %w(id x y z freq)
      neurons.each do |neuron|
        freq = neuron.memories.map{|i| i.last.values.inject(:+) }.reject{|u| u.nil? }.inject(:+)
        freq = 0 unless freq.is_a?(Numeric)
        csv << [neuron.id, neuron.x, neuron.y, neuron.z, freq]
      end
    end
    return 'OK!'
  end

  def memory_threads_to_csv(thread_id = nil)
    threads = if thread_id
                [memory_threads.find { |t| t.id.eql?(thread_id) }]
              else
                memory_threads
              end

    CSV.open("memory_threads.csv", "wb") do |csv|
      csv << %w(x y z color)
      threads.each do |memory_thread|
        memory_thread.thread.each do |position|
          csv << position.push(memory_thread.id).map(&:to_s)
        end
      end
    end
    return 'OK!'
  end
end