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
        if !nonSimulatedMoves.isEmpty || childNodes.isEmpty {
            return self
        }
        let selected = childNodes.max { (node1, node2) -> Bool in
            node1.uct(explorationConstant, totalNumberOfSimulations: numberOfSimulations)
                < node2.uct(explorationConstant, totalNumberOfSimulations: numberOfSimulations)
        }
        return selected! // We checked earlier that childNodes is not empty, so forced unwrap is safe.
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
}
