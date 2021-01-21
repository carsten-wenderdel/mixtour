import Foundation
import Core

final class Node {

    var state: MIXCoreBoard // Could also be a let, but this way we need less memory copies of state
    let move: MIXCoreMove? // The move that has lead to the state above
    unowned var parent: Node? // This was weak before - and made the whole algorithm taking 70% more time!
    var nonSimulatedMoves: [MIXCoreMove]

    var childNodes = [Node]()
    var numberOfSimulations: Float = 0.0
    var numberOfWins: Float = 0.0

    init(state: MIXCoreBoard) {
        self.state = state
        self.move = nil
        self.parent = nil
        self.nonSimulatedMoves = Board.allLegalMoves(&self.state).shuffled()
    }

    /// Used for expansion
    init<T>(parent: Node, move: MIXCoreMove, rng: inout T) where T: RandomNumberGenerator {
        state = parent.state
        Core.makeMove(&state, move) // This will change the state
        self.move = move
        self.parent = parent
        nonSimulatedMoves = Board.allLegalMoves(&state).shuffled(using: &rng)
    }

    func selectedNodeForNextVisit(_ explorationConstant: Float) -> Node {
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
    private func uct(_ explorationConstant: Float, totalNumberOfSimulations: Float) -> Float {
        return (numberOfWins / numberOfSimulations)
            + explorationConstant * sqrt(log(totalNumberOfSimulations) / numberOfSimulations)
    }

    func expand<T>(_ rng: inout T) -> Node where T: RandomNumberGenerator {
        if Core.isGameOver(&state) {
            return self
        }
        // No need to select a random move, the array is already shuffled
        guard let move = nonSimulatedMoves.popLast() else {
            assertionFailure("If moves array is empty, select should have gone deeper in tree")
            return self
        }
        let newChild = Node(parent: self, move: move, rng: &rng)
        childNodes.append(newChild)
        return newChild
    }

    func simulate<T>(moveBuffer: inout MIXMoveArray, rng: inout T) -> MIXCorePlayer where T: RandomNumberGenerator {
        var board = state
        while (!Core.isGameOver(&board)) {
            Core.arrayOfLegalMoves(&board, &moveBuffer)
            let randomIndex = Int.random(in: 0..<moveBuffer.n, using: &rng)
            let randomMove = moveBuffer.a[randomIndex]
            Core.makeMove(&board, randomMove)
        }
        return Core.winner(&board)
    }

    func backpropagate(_ winner: MIXCorePlayer) {
        let draw = (winner == MIXCorePlayerUndefined)
        var node = self
        while true {
            if draw {
                node.numberOfWins += 0.5
            } else if Core.playerOnTurn(&node.state) != winner {
                node.numberOfWins += 1
            }
            node.numberOfSimulations += 1

            // Helps with debugging, not needed for functionality:
//            node.childNodes.sort( by: { (node1, node2) -> Bool in
//                let winRate1 = node1.numberOfWins / node1.numberOfSimulations
//                let winRate2 = node2.numberOfWins / node2.numberOfSimulations
//                return winRate1 < winRate2
//            })

            if let theParent = node.parent {
                node = theParent
            } else {
                break
            }
        }
    }

    func winnerMove() -> MIXCoreMove? {
        // Literature for Monte Carlo Tree Search says we should pick the
        // node with the most visits. Some implementations take the node
        // with the best win rate (numberOfWins / numberOfSimulations).
        // In both cases the number of wins should be the biggest, even
        // more so.
        let winnerNode = childNodes.max { (node1, node2) -> Bool in
            return node1.numberOfWins < node2.numberOfWins
        }
        return winnerNode?.move
    }
}

