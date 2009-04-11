# Some code adapted from gga4r gem (library), fixing existing bugs
# Still needs to be integrated into the framework
class GeneticStrategy
  attr_accessor :population

  def initialize(chromosome, initial_population_size, generations)
    @chromosome = chromosome
    @population_size = initial_population_size
    @max_generation = generations
    @generation = 0
  end

  def run
    generate_initial_population
    @max_generation.times do
      selected_to_breed = selection
      offsprings = reproduction selected_to_breed
      replace_worst_ranked offsprings
    end
    return best_chromosome
  end

  def generate_initial_population
    @population = []
    @population_size.times do
      population << @chromosome.seed
    end
  end

  def selection
    @population.sort! { |a, b| b.fitness <=> a.fitness}
    best_fitness = @population[0].fitness
    worst_fitness = @population.last.fitness
    acum_fitness = 0
    if best_fitness-worst_fitness > 0
      @population.each do |chromosome|
        chromosome.normalized_fitness = (chromosome.fitness - worst_fitness)/
          (best_fitness-worst_fitness)
        acum_fitness += chromosome.normalized_fitness
      end
    else
      @population.each { |chromosome| chromosome.normalized_fitness = 1 }
    end
    selected_to_breed = []
    ((2 * @population_size) / 3).times do
      selected_to_breed << select_random_individual(acum_fitness)
    end
    selected_to_breed
  end

  def reproduction(selected_to_breed)
    offsprings = []
    0.upto(selected_to_breed.length/2-1) do |i|
      offsprings << @chromosome.reproduce(selected_to_breed[2*i],
                                          selected_to_breed[2*i+1])
    end
    @population.each do |individual|
      @chromosome.mutate(individual)
    end
    return offsprings
  end

  def replace_worst_ranked(offsprings)
    size = offsprings.length
    @population = @population [0..((-1*size)-1)] + offsprings
  end

  def best_chromosome
    the_best = @population[0]
    @population.each do |chromosome|
      the_best = chromosome if chromosome.fitness > the_best.fitness
    end
    return the_best
  end

  private

  def select_random_individual(acum_fitness)
    select_random_target = acum_fitness * rand
    local_acum = 0
    @population.each do |chromosome|
      local_acum += chromosome.normalized_fitness
      return chromosome if local_acum >= select_random_target
    end
  end
end


# Represents expression a >= 5 & b <= 3
# Tries to make the whole expression true
class SampleChromosome
  attr_accessor :data, :normalized_fitness

  def initialize(data)
    @data = data
  end

  def fitness
    a = data[0]
    b = data[1]
    if 5 >= a
      c = 5 - a
    else
      c = 0
    end
    if b >= 3
      d = b - 3
    else
      d = 0
    end
    @fitness = -1 * (c + d)
  end

  def self.mutate(chromosome)
    s1 = rand(2) == 1 ? -1 : 1
    s2 = rand(2) == 1 ? -1 : 1
    chromosome.data[0] = chromosome.data[0] + ( s1 * rand(2))
    chromosome.data[1] = chromosome.data[1] + ( s2 * rand(2))
  end

  def self.reproduce(a, b)
    if rand(2)
      c = a.data
    else
      c = b.data
    end
    self.new([c[0], c[1]])
  end

  def self.seed
    self.new([rand(100), rand(100)])
  end
end
