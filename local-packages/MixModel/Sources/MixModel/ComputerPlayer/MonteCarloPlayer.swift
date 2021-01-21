import Foundation
import Core

public final class MonteCarloPlayer {
    
    private var rng: XorShiftRNG
    private let explorationConstant: Float
    private let numberOfIterations: Int

    public static var beginner: MonteCarloPlayer {
        MonteCarloPlayer(numberOfIterations: 1_000, explorationConstant: 2)
    }
    public static var advanced: MonteCarloPlayer {
        MonteCarloPlayer(numberOfIterations: 100_000, explorationConstant: 2)
    }
    public static var measuring: MonteCarloPlayer {
        MonteCarloPlayer(numberOfIterations: 100_000, explorationConstant: 2, rng: XorShiftRNG(1))
    }

    public convenience init(numberOfIterations: Int, explorationConstant: Float) {
        self.init(
            numberOfIterations: numberOfIterations,
            explorationConstant: explorationConstant,
            rng: XorShiftRNG(UInt64.random(in: UInt64.min...UInt64.max))
        )
    }

    init(
        numberOfIterations: Int,
        explorationConstant: Float,
        rng: XorShiftRNG
    ) {
        assert(numberOfIterations > 0)
        self.numberOfIterations = numberOfIterations
        self.explorationConstant = explorationConstant
        self.rng = rng
    }

    /// Returns nil if game is over
    public func bestMove(_ board: Board) -> Move? {
        guard !board.isGameOver() else {
            assertionFailure("Only use it with ongoing games")
            return nil
        }

        let root = Node(state: board.coreBoard)

        for _ in 0..<numberOfIterations {
            let selected = root.selectedNodeForNextVisit(explorationConstant)
            let expanded = selected.expand(&rng)
            let winner = expanded.simulate(&rng)
            expanded.backpropagate(winner)
        }

        guard let coreMove = root.winnerMove() else {
            assertionFailure("Game not ended, so there should be a move")
            return nil
        }
        return Move(coreMove)
    }
}
