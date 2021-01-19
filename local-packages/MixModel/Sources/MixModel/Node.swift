import Foundation
import Core

final class Node {

    var state: MIXCoreBoard // Could also be a let, but this way we need less memory copies of state
    let move: MIXCoreMove?
    weak var parent: Node?
    var nonSimulatedMoves: [MIXCoreMove]

    var childNodes = [Node]()
    var numberOfSimulations = 0.0
    var numberOfWins = 0.0

    init(state: MIXCoreBoard) {
        self.state = state
        self.move = nil
        self.parent = nil
        self.nonSimulatedMoves = Board.allLegalMoves(&self.state).shuffled()
    }

    /// Used for expansion
    init(parent: Node, move: MIXCoreMove) {
        state = parent.state
        Core.makeMove(&state, move) // This will change the state
        self.move = move
        self.parent = parent
        nonSimulatedMoves = Board.allLegalMoves(&state).shuffled()
    }

    func selectedNodeForNextVisit(_ explorationConstant: Double) -> Node {
        var selected = self
        while selected.nonSimulatedMoves.isEmpty && !selected.childNodes.isEmpty {
            selected = selected.childNodes.max { (node1, node2) -> Bool in
                let uct1 = node1.uct(explorationConstant, totalNumberOfSimulations: selected.numberOfSimulations)
                let uct2 = node2.uct(explorationConstant, totalNumberOfSimulations: selected.numberOfSimulations)
                return uct1 < uct2
            }!
        }
        return selected
    }

    // Upper Confidence Bound applied to trees
    private func uct(_ explorationConstant: Double, totalNumberOfSimulations: Double) -> Double {
        return (numberOfWins / numberOfSimulations)
            + explorationConstant * sqrt(log(totalNumberOfSimulations) / numberOfSimulations)
    }

    func expand() -> Node? {
        // No need to select a random move, the array is already shuffled
        guard let move = nonSimulatedMoves.popLast() else {
            return nil
        }
        let newChild = Node(parent: self, move: move)
        childNodes.append(newChild)
        return newChild
    }

    func simulate() -> MIXCorePlayer {
        var board = state
        while (!Core.isGameOver(&board)) {
            guard let move = Board.allLegalMoves(&board).randomElement() else {
                assertionFailure("If game is not over, there must be a legal move")
                return MIXCorePlayerUndefined
            }
            Core.makeMove(&board, move)
        }
        return Core.winner(&board)
    }
}
