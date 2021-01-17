import XCTest
@testable import MixModel

class NodeTests : XCTestCase {

    private static var testNode: Node {
        let leastSimulations = Node()
        leastSimulations.numberOfSimulations = 10
        leastSimulations.numberOfWins = 5

        let ignored = Node()
        ignored.numberOfSimulations = 20
        ignored.numberOfWins = 10

        let bestWinRate = Node()
        bestWinRate.numberOfSimulations = 20
        bestWinRate.numberOfWins = 11

        let parent = Node()
        parent.childNodes = [leastSimulations, ignored, bestWinRate]
        parent.numberOfSimulations = parent.childNodes.reduce(0.0, { sum, node in
            sum + node.numberOfSimulations
        })
        parent.numberOfWins = parent.childNodes.reduce(0.0, { sum, node in
            sum + node.numberOfWins
        })
        return parent
    }

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
        parent.nonSimulatedMoves = [.pass]

        // When
        let selected = parent.selectedNodeForNextVisit(0.3)

        // Then
        XCTAssert(selected === parent)
    }

    func testSelectNodeReturnsSelfIfNoChildNodesExist() {
        // Given
        let parent = Node()

        // When
        let selected = parent.selectedNodeForNextVisit(0.3)

        // Then
        XCTAssert(selected === parent)
    }
}
