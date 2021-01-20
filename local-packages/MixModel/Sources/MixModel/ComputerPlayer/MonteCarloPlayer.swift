import Foundation
import Core

public final class MonteCarloPlayer {
    
    private let explorationConstant: Double
    private let numberOfIterations: Int

    public static var beginner: MonteCarloPlayer {
        MonteCarloPlayer(numberOfIterations: 1_000, explorationConstant: 2)
    }
    public static var advanced: MonteCarloPlayer {
        MonteCarloPlayer(numberOfIterations: 100_000, explorationConstant: 2)
    }

    public init(numberOfIterations: Int, explorationConstant: Double) {
        assert(numberOfIterations > 0)
        self.numberOfIterations = numberOfIterations
        self.explorationConstant = explorationConstant
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
            let expanded = selected.expand()
            let winner = expanded.simulate()
            expanded.backpropagate(winner)
        }

        guard let coreMove = root.winnerMove() else {
            assertionFailure("Game not ended, so there should be a move")
            return nil
        }
        return Move(coreMove)
    }
}
