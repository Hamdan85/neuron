# Neron Project

## Parts

### Neuron

Should be instance of a billion of units, runnin in threads (async) with an argument and an output.

Neurons should be disposed in a spacial order (a cubic for example). It should be receiving inputs from its upper neurons 
and then outputting its return to the lower ones.

The internal calculations should be one that distributes the path randomly to the near lower neurons, but a path 
that has already worked should be prioritized.

Need to stabilish a way to introduce feedback on these structures.

* Neuron instance should receive an information by activation (not data)
* Neuron instance should also receive the neuron that send the information to prevent re-feeding
* Neuron instance should have an array of memories (this  could be a db for each neuron)
* Neuron Memory should be an array with the input received and the output gave: [receiver_id, next_neuron_id]

### Sense

Sense is a Input structure. It must receive a continuous flow of information and deliver it to upper neurons
following the same rule that all neurons has: try new paths, but prioritize the one that you know.

Sense should be hearing a port (sock) or memory address continuously and delivering data to neurons. It should be hearing, 
for exempla, a stream of a typing conversation and catch chr in a determinate data cycle (x iteractions per second)

### Peripheral

Peripheral is a Output structure. It should be hearing SOME of the lower neurons. This way, we stabilish that each peripheral
has its own purposes and kinds of feedback... 

For example: your arm doesnt necessarily move when you hear something, but it necessarily moves when it get stung by a bee.

This happens because the information flow of information through neurons was calibrated to a path that leads to this 
specific peripheral (or output)

### Brain

The wrap class that initialize and unite all neurons.

## DataFlow

Stabilishing for example a cubic neuron brain with a line of 1000000 neurons, we have  1x10^18 neurons instance running.
They must know which neurons are available by its position that should be calculated by its ID.

Eg: 
In a 9 neuron brain, the 9th neuron its still in the first layer: 9 (id) / 9 (per layer neuron amount) = 1

Check positioner.rb

> Input (Sense) > First Neurons > Each Neuron on Path (computes outcome) > Next Neuron select > Outcome
