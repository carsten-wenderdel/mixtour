import Foundation
import Combine
import MixModel

class BoardViewModel: ObservableObject {

    private let board: ModelBoard

    // MARK: Initializers

    init(board: ModelBoard) {
        self.board = board
    }

    convenience init() {
        self.init(board: ModelBoard())
    }

    // Change state

    @discardableResult public func setPiece(_ square: ModelSquare) -> Bool {
        let move = ModelMove(setPieceTo: square)
        return makeMoveIfLegal(move)
    }

    @discardableResult public func makeMoveIfLegal(_ move: ModelMove) -> Bool {
        if board.isMoveLegal(move) {
            objectWillChange.send()
        }
        return board.makeMoveIfLegal(move)
    }


    // Retrieve information

    func piecesAtSquare(_ square: ModelSquare) -> [ModelPlayer] {
        return board.piecesAtSquare(square)
    }

    // Computer player information

    func bestMove() -> ModelMove? {
        return board.bestMove()
    }
}
