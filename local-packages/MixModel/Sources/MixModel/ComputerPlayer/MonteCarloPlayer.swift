import Foundation
import Core

// This class is not thread safe. bestMove(:) may only be called by one instance at the same time.
public final class MonteCarloPlayer {

    public static let perfectExploration: Float = 0.59
    
    private var rng: XorShiftRNG
    private let explorationConstant: Float
    private let numberOfIterations: Int
    private let timeToThink: TimeInterval?
    private var moveBuffer = Core.newMoveArray()
    private var thinking = false // Again: This class is not thread safe.

    public static var beginner: MonteCarloPlayer {
        MonteCarloPlayer(numberOfIterations: 1_000, explorationConstant: perfectExploration)
    }
    public static var advanced: MonteCarloPlayer {
        MonteCarloPlayer(numberOfIterations: 100_000, explorationConstant: perfectExploration)
    }
    public static var measuring: MonteCarloPlayer {
        let player = MonteCarloPlayer(numberOfIterations: 100_000, explorationConstant: perfectExploration, rng: XorShiftRNG(1))
        return player
    }

    public convenience init(config: MCPlayerConfig) {
        self.init(numberOfIterations: config.rawValue)
    }

    public convenience init(numberOfIterations: Int, explorationConstant: Float = perfectExploration) {
        self.init(
            numberOfIterations: numberOfIterations,
            explorationConstant: explorationConstant,
            rng: XorShiftRNG(UInt64.random(in: UInt64.min...UInt64.max))
        )
    }

    public convenience init(timeToThink: TimeInterval) {
        self.init(
            numberOfIterations: 0,
            explorationConstant: Self.perfectExploration,
            rng: XorShiftRNG(UInt64.random(in: UInt64.min...UInt64.max)),
            timeToThink: timeToThink
        )
    }

    init(
        numberOfIterations: Int,
        explorationConstant: Float,
        rng: XorShiftRNG,
        timeToThink: TimeInterval? = nil
    ) {
        assert(numberOfIterations > 0 || timeToThink != nil)
        self.numberOfIterations = numberOfIterations
        self.explorationConstant = explorationConstant
        self.rng = rng
        self.timeToThink = timeToThink
    }

    /// Returns nil if game is over
    public func bestMove(_ board: Board) -> Move? {
        print("BestMove")
        guard !board.isGameOver() else {
            assertionFailure("Only use it with ongoing games")
            return nil
        }
        guard thinking == false else {
            assertionFailure("This class is not thread safe. Best call this method always from the same thread.")
            return nil
        }
        thinking = true // This should find 99% of misuses, but not all - no semaphore.

        let root = Node(state: board.coreBoard)

        if let timeToThink = timeToThink {
            let targetDate = Date(timeIntervalSinceNow: timeToThink).timeIntervalSinceReferenceDate
            repeat {
                iterate(root)
            } while Date.timeIntervalSinceReferenceDate < targetDate
        } else {
            for _ in 0..<numberOfIterations {
                iterate(root)
            }
        }

        thinking = false
        guard let coreMove = root.winnerMove() else {
            assertionFailure("Game not ended, so there should be a move")
            return nil
        }
        return Move(coreMove)
    }

    private func iterate(_ root: Node) {
        let selected = root.selectedNodeForNextVisit(explorationConstant)
        let expanded: Node
        let winner: MIXCorePlayer
        expanded = selected.expand(&rng)
        winner = expanded.simulate(moveBuffer: &moveBuffer, rng: &rng)
        expanded.backpropagate(winner)
    }

    deinit {
        Core.destroyMoveArray(moveBuffer)
    }
}
