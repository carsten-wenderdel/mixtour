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

    // MARK: Change state

    func trySettingPieceTo(_ square: ModelSquare) {
        let move = ModelMove(setPieceTo: square)
        guard board.isMoveLegal(move) else {
            return
        }

        objectWillChange.send()
        board.makeMoveIfLegal(move)

        if let move = board.bestMove() {
            objectWillChange.send()
            board.makeMoveIfLegal(move)
        }
    }

    // MARK: Retrieve information

    func piecesAtSquare(_ square: ModelSquare) -> [ModelPlayer] {
        return board.piecesAtSquare(square)
    }
}
