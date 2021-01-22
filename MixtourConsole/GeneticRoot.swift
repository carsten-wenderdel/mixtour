import Foundation
import MixModel
import SwiftGenetics

typealias RealGene2 = ContinuousGene<Double, LivingStringEnvironment>
typealias NeuroevolutionString2 = LivingStringGenome<RealGene2>

class RootEvaluator: SynchronousFitnessEvaluator {
    typealias G = NeuroevolutionString2

    let square: Double
    var count = 0

    init(_ square: Double) {
        self.square = square
    }

    func fitnessFor(organism: Organism<G >, solutionCallback: (G , Double) -> ()) -> FitnessResult {
        count += 1
        let value = organism.genotype.genes.first!.value
        let diff = abs(value * value - square)
        let returnValue = 1/diff
//        return FitnessResult(fitness: returnValue)
        return FitnessResult(fitness: -diff * 1_000)
    }
}


struct MockLogDelegate: EvolutionLoggingDelegate {
    typealias G = NeuroevolutionString2

    func evolutionStartingEpoch(_ i: Int) {

    }

    func evolutionFinishedEpoch(_ i: Int, duration: TimeInterval, population: Population<G>) {
        
    }

    func evolutionFoundSolution(_ solution: G, fitness: Double) {

    }
}

class GeneticRoot {


    /// Runs a GA that aims to find a sorted string of real numbers.
    /// NOTE: this test is stochastic and may fail once in a blue moon.
    func root(_ square: Double) -> Double {
        let maxEpochs = 50
        // Define environment.
        let environment = LivingStringEnvironment(
            populationSize: 12,
//            selectionMethod: .roulette,
//            selectionMethod: .truncation(takePortion: 0.8),
            selectionMethod: .tournament(size: 2),
            selectableProportion: 1.0,
            mutationRate: 0.1,
            crossoverRate: 0.5,
            numberOfElites: 4,
            numberOfEliteCopies: 2,
            parameters: [
                ContinuousEnvironmentParameter.mutationSize.rawValue: AnyCodable(10.1),
                ContinuousEnvironmentParameter.mutationType.rawValue: AnyCodable(ContinuousMutationType.uniform.rawValue)
            ]
        )
        // Build initial population.
        let population = Population<NeuroevolutionString2>(environment: environment, evolutionType: .standard)
        for i in 0..<environment.populationSize {
            let startValue = square / Double(environment.populationSize) * Double(i)
            let genes = [RealGene2(value: startValue)]
            let genotype = NeuroevolutionString2(genes: genes)
            let organism = Organism<LivingStringGenome>(fitness: nil, genotype: genotype)
            population.organisms.append(organism)
        }
        // Evolve!
        let evaluator = RootEvaluator(square)
        let logDelegate = MockLogDelegate()
        let ga = ConcurrentSynchronousEvaluationGA(fitnessEvaluator: evaluator, loggingDelegate: logDelegate)
        let evolutionConfig = EvolutionAlgorithmConfiguration(maxEpochs: maxEpochs, algorithmType: population.evolutionType)
        ga.evolve(population: population, configuration: evolutionConfig)
        // Check solution.
        let bestOrganism = population.bestOrganism!
        let bestGene = bestOrganism.genotype.genes.first

        print("count: \(evaluator.count)")

        return bestGene!.value
    }


}
