import Foundation
import MixModel

class BoardViewModel: ObservableObject {

    // MARK variables set from outside
    private var board: ModelBoard
    private var humanColor: ModelPlayer
    private var computerPlayer: ComputerPlayer

    // MARK internal state
    private var previousBoard: ModelBoard?
    private var animatableMove: Move?
    private var setSquare: Square?
    private var computerPlayerIsThinking = false
    
    private var pickedPieces: PickedPieces? {
        didSet {
            if pickedPieces != nil {
                animatableMove = nil
            }
        }
    }

    private struct PickedPieces {
        var square: Square
        var number: Int
    }

    private var computerColor: ModelPlayer { humanColor == .white ? .black : .white }

    // Public properties

    var undoPossible: Bool { previousBoard != nil }
    var gameOver: Bool { board.isGameOver() }

    var interactionDisabled: Bool { computerPlayerIsThinking || board.isGameOver() }

    var gameOverText: String {
        guard let winner = board.winner() else {
            return " "
        }
        if winner == humanColor {
            return "You have won!"
        } else {
            return "You have lost"
        }
    }

    // MARK: Initializers

    init(
        board: ModelBoard = ModelBoard(),
        color: ModelPlayer = .white,
        computer: ComputerPlayer = .beginner
    ) {
        self.board = board
        self.humanColor = color
        self.computerPlayer = computer
    }

    // MARK: Change state

    func undo() {
        if let previousBoard = previousBoard {
            reset(board: previousBoard)
        }
    }

    func reset(board: ModelBoard = ModelBoard(), color: ModelPlayer = .white) {
        objectWillChange.send()
        previousBoard = nil
        animatableMove = nil
        pickedPieces = nil
        setSquare = nil
        self.board = board
        self.humanColor = color
        if (color == .white) {
            computerPlayerIsThinking = false
        } else {
            computerPlayerIsThinking = true
            letComputermakeNextMove()
        }
    }

    func pickPieceFromSquare(_ square: Square) {
        objectWillChange.send()
        let oldNumber = numberOfPickedPiecesAt(square)
        let number = (oldNumber + 1) % board.heightOfSquare(square)
        pickedPieces = PickedPieces(square: square, number: number)
    }

    func stopPickingOtherThan(_ square: Square) {
        if square != pickedPieces?.square {
            objectWillChange.send()
            pickedPieces = nil
        }
    }

    @discardableResult func tryDrag(_ numberOfPieces: Int, from: Square, to: Square ) -> Bool {
        let move = Move(from: from, to: to, numberOfPieces: numberOfPieces)
        guard board.isMoveLegal(move) else {
            return false
        }
        makeMove(move)
        return true
    }

    @discardableResult func trySettingPieceTo(_ square: Square) -> Bool {
        let move = Move(setPieceTo: square)
        guard board.isMoveLegal(move) else {
            return false
        }
        makeMove(move)
        return true
    }

    private func makeMove(_ move: Move) {
        if (board.playerOnTurn() != humanColor) {
            assertionFailure("Human should only play their own pieces")
            return
        }
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
            self.letComputermakeNextMove()
        }
    }

    private func letComputermakeNextMove() {
        if let move = self.computerPlayer.bestMove(self.board) {
            self.objectWillChange.send()
            self.setSquare = move.isMoveDrag() ? nil : move.to
            self.computerPlayerIsThinking = false
            self.animatableMove = move
            self.board.makeMoveIfLegal(move)
        }
    }

    // MARK: Retrieve information

    func unusedPiecesHuman() -> PieceStackPart {
        return unusedPiecesPartFor(humanColor)
    }

    func unusedPiecesComputer() -> PieceStackPart {
        return unusedPiecesPartFor(computerColor)
    }

    private func unusedPiecesPartFor(_ player: ModelPlayer) -> PieceStackPart {
        let pieces = board.unusedPiecesForPlayer(player).enumerated().map { (index, piece) in
            PieceViewModel(color: piece.color, id: piece.id, zIndex: Double(index))
        }
        return PieceStackPart(
            pieces: pieces.reversed(),
            square: Square(column: 6, line: 6),
            useDrag: true
        )
    }

    private func numberOfPickedPiecesAt(_ square: Square) -> Int {
        if let pieces = pickedPieces, square == pieces.square {
            return pieces.number
        } else {
            return 0
        }
    }

    func stackAtSquare(_ square: Square) -> PieceStackViewModel {
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
        return zIndexFor(\Square.line, value: line)
    }

    func zIndexForColumn(_ column: Int) -> Double {
        return zIndexFor(\Square.column, value: column)
    }

    /// keyPath can be "column" or "line"
    private func zIndexFor(_ keyPath: KeyPath<Square, Int>, value: Int) -> Double {
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
