import XCTest
import SnapshotTesting
@testable import mixtour

class AppStoreIconSnapshotTests: XCTestCase {

    override class func setUp() {
        super.setUp()
//        isRecording = true
    }

    // This won't work on Bitrise, so let's deactivate it.
    // When executed, this stores a png used as App Store icon.
    // Rest is then rendered on https://appicon.co/
    func _testAppStoreIcon() throws {
        let view = AppStoreIconView()

        assertSnapshot(
            matching: view,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 512, height: 512)
            )
        )
    }

}
