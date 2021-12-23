import XCTest
@testable import mixtour
@testable import MixModel

class ComputerPlayerViewModelTests: XCTestCase {

    func testDescriptionIsGerman() {
        // Given
        let vm = ComputerPlayerViewModel(config: .beginner2)

        // Then
        XCTAssertEqual(vm.description, "Computer: Anfänger 2", "Test plan needs set to German")
    }
}
