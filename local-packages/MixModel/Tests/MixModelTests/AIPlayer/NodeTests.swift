import XCTest
@testable import MixModel

class NodeTests : XCTestCase {

    func testSelectedNodeForNextVisit() {
        // Given
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

        // When
        var selected = parent.selectedNodeForNextVisit(0.25)
        // Then
        XCTAssert(selected === bestWinRate)

        // And When
        // Bigger explorationConstant means less simulations are more important than high win rate
        selected = parent.selectedNodeForNextVisit(0.3)
        // Then
        XCTAssert(selected === leastSimulations)
    }
}
