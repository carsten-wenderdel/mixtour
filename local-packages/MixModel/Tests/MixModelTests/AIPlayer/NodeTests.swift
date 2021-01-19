import XCTest
import Core
@testable import MixModel

class NodeTests : XCTestCase {

    // MARK: fake nodes to help testing

    private static func dummyNode(simulations: Double, wins: Double) -> Node {
        var board = MIXCoreBoard()
        Core.resetCoreBoard(&board)
        let node = Node(state: board)
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
        let bestWinRate = dummyNode(simulations: 20, wins: 11)

        let bestWinChild1 = dummyNode(simulations: 10, wins: 2)
        let bestWinChild2 = dummyNode(simulations: 10, wins: 9)
        bestWinRate.childNodes = [bestWinChild1, bestWinChild2]

        let parent = dummyNode()
        parent.childNodes = [leastSimulations, ignored, bestWinRate]
        parent.numberOfSimulations = parent.childNodes.reduce(0.0, { sum, node in
            sum + node.numberOfSimulations
        })
        parent.numberOfWins = parent.childNodes.reduce(0.0, { sum, node in
            sum + node.numberOfWins
        })
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
        let node = Node(state: MIXCoreBoard.new())
        XCTAssertEqual(node.nonSimulatedMoves.count, 25)
        XCTAssertEqual(node.childNodes.count, 0)

        // When
        let newChild = node.expand()

        // Then
        XCTAssertEqual(node.nonSimulatedMoves.count, 24)
        XCTAssertEqual(node.childNodes.count, 1)
        XCTAssert(node.childNodes.first === newChild)
    }

    // MARK: Test Simulation

    func testSimulation() {
        // Just try out some random simulations. We are happy if they terminate.
        let node = Node(state: MIXCoreBoard.new())
        for _ in 0..<100 {
            let winner = node.simulate()
            XCTAssertTrue(winner == MIXCorePlayerBlack || winner == MIXCorePlayerWhite || winner == MIXCorePlayerUndefined)
        }
    }
}
