import XCTest
import Core
@testable import MixModel

class NodeTests : XCTestCase {

    // MARK: fake nodes to help testing

    private var rng = XorShiftRNG.reproducable

    private static func dummyNode(simulations: Double, wins: Double, move: Move? = nil) -> Node {
        var rng = XorShiftRNG.reproducable
        var board = MIXCoreBoard()
        Core.resetCoreBoard(&board)
        let node: Node
        if let move = move {
            node = Node(parent: Node(state: board), move: move.coreMove(), rng: &rng)
        } else {
            node = Node(state: board)
        }
        node.nonSimulatedMoves = []
        node.numberOfSimulations = simulations
        node.numberOfWins = wins
        return node
    }

    private static func dummyNode() -> Node {
        return dummyNode(simulations: 0, wins: 0)
    }

    private static var testNode: Node {
        let leastSimulations = dummyNode(simulations: 10, wins: 5)
        let ignored = dummyNode(simulations: 20, wins: 10)
        let bestWinRate = dummyNode(simulations: 20, wins: 11, move: .set(to: Square(column: 2, line: 1)))

        let bestWinChild1 = dummyNode(simulations: 10, wins: 2)
        let bestWinChild2 = dummyNode(simulations: 10, wins: 9)
        bestWinRate.childNodes = [bestWinChild1, bestWinChild2]
        bestWinRate.childNodes.forEach { $0.parent = bestWinRate }

        let parent = dummyNode()
        parent.childNodes = [leastSimulations, ignored, bestWinRate]
        parent.numberOfSimulations = parent.childNodes.reduce(0.0, { sum, node in
            sum + node.numberOfSimulations
        })
        parent.numberOfWins = parent.childNodes.reduce(0.0, { sum, node in
            sum + node.numberOfWins
        })
        parent.childNodes.forEach { child in
            child.parent = parent
            Core.setTurnDirectly(&child.state, MIXCorePlayerBlack)
        }
        return parent
    }

    // MARK: Test Selection

    func testSelectNodePicksBestWinRateForSmallConstantsAndGoesTwoLevelsDeep() {
        // Given
        let parent = Self.testNode

        // When
        let selected = parent.selectedNodeForNextVisit(0.25)

        // Then
        XCTAssertEqual(selected.numberOfSimulations, 10)
        XCTAssertEqual(selected.numberOfWins, 9)
    }

    func testSelectNodePicksLeastSimulationsForBigConstants() {
        // Given
        let parent = Self.testNode

        // When
        let selected = parent.selectedNodeForNextVisit(0.3)

        // Then
        XCTAssertEqual(selected.numberOfSimulations, 10)
        XCTAssertEqual(selected.numberOfWins, 5)
    }

    func testSelectNodeReturnsSelfIfSomeUntriedMoveExists() {
        // Given
        let parent = Self.testNode
        parent.nonSimulatedMoves = [Move.pass.coreMove()]

        // When
        let selected = parent.selectedNodeForNextVisit(0.3)

        // Then
        XCTAssert(selected === parent)
    }

    func testSelectNodeReturnsSelfIfNoChildNodesExist() {
        // Given
        let parent = Self.dummyNode()

        // When
        let selected = parent.selectedNodeForNextVisit(0.3)

        // Then
        XCTAssert(selected === parent)
    }

    // MARK: Test Expansion

    func testExpansionReducesMovesAndAddsNode() {
        // Given
        var rng = XorShiftRNG.reproducable
        let node = Node(state: MIXCoreBoard.new())
        XCTAssertEqual(node.nonSimulatedMoves.count, 25)
        XCTAssertEqual(node.childNodes.count, 0)

        // When
        let newChild = node.expand(&rng)

        // Then
        XCTAssertEqual(node.nonSimulatedMoves.count, 24)
        XCTAssertEqual(node.childNodes.count, 1)
        XCTAssert(node.childNodes.first === newChild)
    }

    func testExpansionDoesNotCreateNewNodeWhenGameOver() {
        // Given
        var rng = XorShiftRNG.reproducable
        let board = Board()
        let square1 = Square(column: 0, line: 0)
        let square2 = Square(column: 0, line: 3)
        board.setPiecesDirectlyToSquare(square1, .white, .black, .white)
        board.setPiecesDirectlyToSquare(square2, .white, .black, .white)
        board.dragPiecesFrom(square1, to: square2, withNumber: 3)
        XCTAssert(board.isGameOver())
        let node = Node(state: board.coreBoard)

        // When
        let potentialChild = node.expand(&rng)

        // Then
        XCTAssertEqual(node.childNodes.count, 0)
        XCTAssert(potentialChild === node)
    }

    // MARK: Test Simulation

    func testSimulation() {
        // Just try out some random simulations. We are happy if they terminate.
        var rng = XorShiftRNG.reproducable
        let node = Node(state: MIXCoreBoard.new())
        for _ in 0..<100 {
            let winner = node.simulate(&rng)
            XCTAssertTrue(winner == MIXCorePlayerBlack || winner == MIXCorePlayerWhite || winner == MIXCorePlayerUndefined)
        }
    }

    // MARK: Test Backpropagation

    func testBackPropagationForWin() {
        // Given
        let parent = Self.testNode
        let grandChild = parent.selectedNodeForNextVisit(0.25)
        let child = grandChild.parent!
        XCTAssert(child.parent === parent)

        let parentSimulations = parent.numberOfSimulations
        let childSimulations = child.numberOfSimulations
        let grandChildSimulations = grandChild.numberOfSimulations

        let parentWins = parent.numberOfWins
        let childWins = child.numberOfWins
        let grandChildWins = grandChild.numberOfWins

        // When
        grandChild.backpropagate(MIXCorePlayerWhite) // That's the difference to the other tests

        // Then
        XCTAssertEqual(parent.numberOfSimulations, parentSimulations + 1)
        XCTAssertEqual(child.numberOfSimulations, childSimulations + 1)
        XCTAssertEqual(grandChild.numberOfSimulations, grandChildSimulations + 1)

        XCTAssertEqual(parent.numberOfWins, parentWins)
        XCTAssertEqual(child.numberOfWins, childWins + 1)
        XCTAssertEqual(grandChild.numberOfWins, grandChildWins)
    }

    func testBackPropagationForLoss() {
        // Given
        let parent = Self.testNode
        let grandChild = parent.selectedNodeForNextVisit(0.25)
        let child = grandChild.parent!
        XCTAssert(child.parent === parent)

        let parentSimulations = parent.numberOfSimulations
        let childSimulations = child.numberOfSimulations
        let grandChildSimulations = grandChild.numberOfSimulations

        let parentWins = parent.numberOfWins
        let childWins = child.numberOfWins
        let grandChildWins = grandChild.numberOfWins

        // When
        grandChild.backpropagate(MIXCorePlayerBlack) // That's the difference to the other tests

        // Then
        XCTAssertEqual(parent.numberOfSimulations, parentSimulations + 1)
        XCTAssertEqual(child.numberOfSimulations, childSimulations + 1)
        XCTAssertEqual(grandChild.numberOfSimulations, grandChildSimulations + 1)

        XCTAssertEqual(parent.numberOfWins, parentWins + 1)
        XCTAssertEqual(child.numberOfWins, childWins)
        XCTAssertEqual(grandChild.numberOfWins, grandChildWins + 1)
    }

    func testBackPropagationForDraw() {
        // Given
        let parent = Self.testNode
        let grandChild = parent.selectedNodeForNextVisit(0.25)
        let child = grandChild.parent!
        XCTAssert(child.parent === parent)

        let parentSimulations = parent.numberOfSimulations
        let childSimulations = child.numberOfSimulations
        let grandChildSimulations = grandChild.numberOfSimulations

        let parentWins = parent.numberOfWins
        let childWins = child.numberOfWins
        let grandChildWins = grandChild.numberOfWins

        // When
        grandChild.backpropagate(MIXCorePlayerUndefined) // That's the difference to the other tests

        // Then
        XCTAssertEqual(parent.numberOfSimulations, parentSimulations + 1)
        XCTAssertEqual(child.numberOfSimulations, childSimulations + 1)
        XCTAssertEqual(grandChild.numberOfSimulations, grandChildSimulations + 1)

        XCTAssertEqual(parent.numberOfWins, parentWins + 0.5)
        XCTAssertEqual(child.numberOfWins, childWins + 0.5)
        XCTAssertEqual(grandChild.numberOfWins, grandChildWins + 0.5)
    }

    // MARK: Test Winner Move

    func testWinnerMoveTakesNodeWithMostWins() {
        // Given
        let node = Self.testNode

        // When
        let winner = node.winnerMove()

        // Then
        // As specified in testNode
        XCTAssertEqual(winner?.to.column, 2)
        XCTAssertEqual(winner?.to.line, 1)
    }
}
