import XCTest
import SnapshotTesting
import MixModel
import SwiftUI
@testable import mixtour

class BoardIllustrationSnapshotTests: XCTestCase {

    // We need to remove the animation, otherwise the pieces are placed too low and not centered horizontally.
    let testAnimationConstants: AnimationConstants = {
        let constants = AnimationConstants()
        constants.pieceAnimation = nil
        return constants
    }()

    override class func setUp() {
        super.setUp()
//        isRecording = true
    }

    // This won't work on Bitrise, so let's deactivate it.
    func _testIllustrationSlowDrawing() throws {
        let view = BoardIllustrationView(Board.example)
            .environment(\.colorScheme, .dark)
            .environmentObject(testAnimationConstants)

        assertSnapshot(
            matching: view,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 200, height: 200)
            )
        )
    }

    // Same test method as above, but 3 times as fast and without shades -> slightly wrong image
    func testIllustrationFastDrawing() throws {
        let view = BoardIllustrationView(Board.example)
            .environment(\.colorScheme, .dark)
            .environmentObject(testAnimationConstants)

        assertSnapshot(
            matching: view,
            as: .image(
                drawHierarchyInKeyWindow: false,
                layout: .fixed(width: 200, height: 200)
            )
        )
    }
}
