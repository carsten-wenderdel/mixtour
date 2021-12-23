import XCTest
@testable import mixtour
@testable import MixModel

class BoardViewModelTests: XCTestCase {

    // MARK: zIndex

    func testHumanSetAnimationIsNotUnderExistingStack() {
        // Given
        let board = Board()
        board.setTurnDirectly(.white)
        let existingSquare = Square(column: 2, line: 3)
        board.setPiecesDirectlyToSquare(existingSquare, .white, .white, .black)

        let vm = BoardViewModel(board: board, color: .white, computerVM: .dummy)

        // When
        let setSquare = Square(column: 1, line: 2)
        vm.trySettingPieceTo(setSquare)

        // Then
        XCTAssert(vm.zIndexForColumn(setSquare.column) > vm.zIndexForColumn(existingSquare.column))
        XCTAssert(vm.zIndexForLine(setSquare.line) > vm.zIndexForLine(existingSquare.line))
    }
}
