import Foundation
import MixModel

class BoardViewModel: ObservableObject {

    private var board: ModelBoard
    private var animatableMove: ModelMove?
    
    private var pickedPieces: PickedPieces? {
        didSet {
            if pickedPieces != nil {
                animatableMove = nil
            }
        }
    }

    private struct PickedPieces {
        var square: ModelSquare
        var number: Int
    }

    // MARK: Initializers

    init(board: ModelBoard) {
        self.board = board
    }

    convenience init() {
        self.init(board: ModelBoard())
    }

    // MARK: Change state

    func reset(board: ModelBoard = ModelBoard()) {
        objectWillChange.send()
        self.animatableMove = nil
        self.pickedPieces = nil
        self.board = board
    }

    func pickPieceFromSquare(_ square: ModelSquare) {
        objectWillChange.send()
        let oldNumber = numberOfPickedPiecesAt(square)
        let number = (oldNumber + 1) % (board.heightOfSquare(square) + 1)
        pickedPieces = PickedPieces(square: square, number: number)
    }

    func trySettingPieceTo(_ square: ModelSquare) {
        let move = ModelMove(setPieceTo: square)
        guard board.isMoveLegal(move) else {
            return
        }

        objectWillChange.send()
        animatableMove = nil
        pickedPieces = nil
        board.makeMoveIfLegal(move)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            if let move = self.board.bestMove() {
                self.objectWillChange.send()
                self.animatableMove = move
                self.board.makeMoveIfLegal(move)
            }
        }
    }

    // MARK: Retrieve information

    private func numberOfPickedPiecesAt(_ square: ModelSquare) -> Int {
        if let pieces = pickedPieces, square == pieces.square {
            return pieces.number
        } else {
            return 0
        }
    }

    func stackAtSquare(_ square: ModelSquare) -> PieceStackViewModel {
        let height = board.heightOfSquare(square)
        let pieces = board.piecesAtSquare(square).enumerated().map { (index, piece) in
            PieceViewModel(color: piece.color, id: piece.id, zIndex: Double(height - index))
        }
        let numberOfPickedPieces = numberOfPickedPiecesAt(square)
        return PieceStackViewModel(
            defaultPieces: Array(pieces.suffix(height - numberOfPickedPieces)),
            pickedPieces: Array(pieces.prefix(numberOfPickedPieces))
        )
    }

    func zIndexForLine(_ line: Int) -> Double {
        return zIndexFor(\ModelSquare.line, value: line)
    }

    func zIndexForColumn(_ column: Int) -> Double {
        return zIndexFor(\ModelSquare.column, value: column)
    }

    /// keyPath can be "column" or "line"
    private func zIndexFor(_ keyPath: KeyPath<ModelSquare, Int>, value: Int) -> Double {
        if let picked = pickedPieces, picked.square[keyPath: keyPath] == value {
            return 3
        } else if animatableMove?.to[keyPath: keyPath] == value {
            return 2
        } else if animatableMove?.from[keyPath: keyPath] == value {
            return 1
        } else {
            return 0
        }
    }
}
