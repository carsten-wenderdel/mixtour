import Foundation
import MixModel

class BoardViewModel: ObservableObject {

    private var board: ModelBoard
    private var previousBoard: ModelBoard?
    private var animatableMove: ModelMove?
    private var setSquare: ModelSquare?
    private var computerPlayerIsThinking = false
    
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

    // Public properties

    var undoPossible: Bool { previousBoard != nil }
    var gameOver: Bool { board.isGameOver() }

    var interactionDisabled: Bool { computerPlayerIsThinking || board.isGameOver() }

    var gameOverText: String {
        switch board.winner() {
        case .white:
            return "You have won!"
        case .black:
            return "You have lost"
        case .none:
            return " "
        }
    }

    // MARK: Initializers

    init(board: ModelBoard) {
        self.board = board
    }

    convenience init() {
        self.init(board: ModelBoard())
    }

    // MARK: Change state

    func undo() {
        if let previousBoard = previousBoard {
            reset(board: previousBoard)
        }
    }

    func reset(board: ModelBoard = ModelBoard()) {
        objectWillChange.send()
        previousBoard = nil
        animatableMove = nil
        pickedPieces = nil
        setSquare = nil
        computerPlayerIsThinking = false
        self.board = board
    }

    func pickPieceFromSquare(_ square: ModelSquare) {
        objectWillChange.send()
        let oldNumber = numberOfPickedPiecesAt(square)
        let number = (oldNumber + 1) % board.heightOfSquare(square)
        pickedPieces = PickedPieces(square: square, number: number)
    }

    func stopPickingOtherThan(_ square: ModelSquare) {
        if square != pickedPieces?.square {
            objectWillChange.send()
            pickedPieces = nil
        }
    }

    @discardableResult func tryDrag(_ numberOfPieces: Int, from: ModelSquare, to: ModelSquare ) -> Bool {
        let move = ModelMove(from: from, to: to, numberOfPieces: numberOfPieces)
        guard board.isMoveLegal(move) else {
            return false
        }
        makeMove(move)
        return true
    }

    @discardableResult func trySettingPieceTo(_ square: ModelSquare) -> Bool {
        let move = ModelMove(setPieceTo: square)
        guard board.isMoveLegal(move) else {
            return false
        }
        makeMove(move)
        return true
    }

    private func makeMove(_ move: ModelMove) {
        objectWillChange.send()
        previousBoard = ModelBoard(board: board)
        computerPlayerIsThinking = true
        animatableMove = nil
        pickedPieces = nil
        setSquare = move.isMoveDrag() ? nil : move.to
        board.makeMoveIfLegal(move)

        let capturedBoard = board
        if (board.isGameOver()) {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            guard self.board === capturedBoard else {
                // Probably a new game was started, so discard this move
                return
            }
            if let move = self.board.bestMove() {
                self.objectWillChange.send()
                self.setSquare = move.isMoveDrag() ? nil : move.to
                self.computerPlayerIsThinking = false
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
            pieces: pieces,
            numberOfPickedPieces: numberOfPickedPieces,
            square: square,
            useDrag: setSquare != square
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
