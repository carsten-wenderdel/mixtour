import XCTest
import Core
@testable import MixModel

class NodeTests : XCTestCase {

    // MARK: fake nodes to help testing

    private static func dummyNode() -> Node {
        var board = MIXCoreBoard()
        Core.resetCoreBoard(&board)
        let node = Node(state: board)
        node.nonSimulatedMoves = []
        return node
    }

    private static var testNode: Node {
        let leastSimulations = dummyNode()
        leastSimulations.numberOfSimulations = 10
        leastSimulations.numberOfWins = 5

        let ignored = dummyNode()
        ignored.numberOfSimulations = 20
        ignored.numberOfWins = 10

        let bestWinRate = dummyNode()
        bestWinRate.numberOfSimulations = 20
        bestWinRate.numberOfWins = 11

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

    func testSelectNodePicksBestWinRateForSmallConstants() {
        // Given
        let parent = Self.testNode

        // When
        let selected = parent.selectedNodeForNextVisit(0.25)

        // Then
        XCTAssertEqual(selected.numberOfWins, 11)
    }

    func testSelectNodePicksLeastSimulationsForBigConstants() {
        // Given
        let parent = Self.testNode

        // When
        let selected = parent.selectedNodeForNextVisit(0.3)

        // Then
        XCTAssertEqual(selected.numberOfSimulations, 10)
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
}
