import XCTest
@testable import MixModel


extension Array {
    /// Maps [1, 2, 3, 4] to [(1,2), (2,3), (3,4)]. Helpful for unit testing, comparing adjacent elements.
    func pairs() -> [(Element, Element)] {
        stride(from: 0, to: self.count - 1, by: 1).map {
            (self[$0], self[$0+1])
        }
    }
}

class MCPlayerConfigTests: XCTestCase {

    // MARK: Array extension

    func testPairs() {
        // Given
        let testArray = [2, 3, 5, 7, 11, 13]

        // When
        let pairs = testArray.pairs()

        // Then
        XCTAssertEqual(pairs.count, testArray.count - 1)

        XCTAssertEqual(pairs[0].0, 2)
        XCTAssertEqual(pairs[0].1, 3)
        XCTAssertEqual(pairs[1].0, 3)
        XCTAssertEqual(pairs[1].1, 5)

        XCTAssertEqual(pairs[4].0, 11)
        XCTAssertEqual(pairs[4].1, 13)
    }

    // MARK: MCPlayerConfig

    func testPairsIsNotEmpty() {
        XCTAssert(MCPlayerConfig.allCases.pairs().count >= 1)
    }

    func testEloDifferenceIsAlways150() {
        for pair in MCPlayerConfig.allCases.pairs() {
            XCTAssertEqual(pair.0.eloRating + 150, pair.1.eloRating)
        }
    }

    func testRawValueIsAlwaysGrowing() {
        for pair in MCPlayerConfig.allCases.pairs() {
            XCTAssertLessThan(pair.0.rawValue, pair.1.rawValue)
        }
    }

    func testRawValueIsGrowingSmallerThanTripling() {
        for pair in MCPlayerConfig.allCases.pairs() {
            XCTAssertGreaterThan(pair.0.rawValue * 3, pair.1.rawValue)
        }
    }
}


