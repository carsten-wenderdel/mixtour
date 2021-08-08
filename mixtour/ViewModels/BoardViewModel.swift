import Foundation
import MixModel

final class BoardViewModel: ObservableObject {

    public enum State {
        /// previousMove would be a computer move
        case humanTurn(previousMove: Move?)
        /// previousMove would be a huamn move
        case computerTurn(previousMove: Move?)

        var setSquare: Square? {
            let move: Move?
            switch self {
            case .humanTurn(let previousMove):
                move = previousMove
            case .computerTurn(let previousMove):
                move = previousMove
            }
            if case let .set(to) = move {
                return to
            } else {
                return nil
            }
        }
    }

    private let computerPlayerQueue = DispatchQueue(label: "com.wenderdel.mixtour", qos: .userInitiated)

    // MARK variables set from outside
    private var board: Board
    private var humanColor: PlayerColor
    private var computerPlayer: MonteCarloPlayer

    // MARK internal state
    private var state: State
    private var previousBoard: Board?
    private var animatableMove: Move?

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

    private var computerColor: PlayerColor { humanColor == .white ? .black : .white }

    // Public properties

    var undoPossible: Bool { previousBoard != nil }
    var gameOver: Bool { board.isGameOver() }

    var interactionDisabled: Bool {
        switch state {
        case .computerTurn:
            return true
        case .humanTurn:
            return false
        }
    }

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
        board: Board = Board(),
        color: PlayerColor = .white,
        computer: MonteCarloPlayer = .beginner
    ) {
        self.board = board
        self.humanColor = color
        self.computerPlayer = computer
        state =
            board.playerOnTurn() == color
            ? .humanTurn(previousMove: nil)
            : .computerTurn(previousMove: nil)
    }

    // MARK: Change state

    func undo() {
        if let previousBoard = previousBoard {
            reset(
                board: previousBoard,
                color: humanColor,
                computer: computerPlayer
            )
        }
    }

    func reset(board: Board = Board(),
               color: PlayerColor,
               computer: MonteCarloPlayer
    ) {
        objectWillChange.send()
        previousBoard = nil
        animatableMove = nil
        pickedPieces = nil
        self.board = board
        self.humanColor = color
        state =
            board.playerOnTurn() == color
            ? .humanTurn(previousMove: nil)
            : .computerTurn(previousMove: nil)
        self.computerPlayer = computer
        if case .computerTurn = state {
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
        let move = Move.drag(from: from, to: to, numberOfPieces: numberOfPieces)
        guard board.isMoveLegal(move) else {
            return false
        }
        makeMove(move)
        return true
    }

    @discardableResult func trySettingPieceTo(_ square: Square) -> Bool {
        let move = Move.set(to: square)
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
        previousBoard = Board(board)
        state = .computerTurn(previousMove: move)
        animatableMove = nil
        pickedPieces = nil
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
            state = .humanTurn(previousMove:move)
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

    private func unusedPiecesPartFor(_ player: PlayerColor) -> PieceStackPart {
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
            useDrag: square != state.setSquare
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
        } else if case let .drag(from, to, _) = animatableMove {
            if to[keyPath: keyPath] == value {
                return 2
            } else if from[keyPath: keyPath] == value {
                return 1
            }
        }
        return 0
    }
}

// MARK: Let computer play against each other
extension BoardViewModel {
    func startComputerPlay() {
        objectWillChange.send()
        reset(
            color: .white,
            computer: MonteCarloPlayer(config: .beginner1)
        )
        makeComputerMove()
    }

    private func makeComputerMove() {
        guard board.isGameOver() == false else {
            return
        }

        computerPlayerQueue.async { [self] in
            let computer: MonteCarloPlayer = board.playerOnTurn()
                == .white
                ? .beginner
                : .advanced
            guard let move = computer.bestMove(board) else {
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                objectWillChange.send()
                board.makeMoveIfLegal(move)
                self.makeComputerMove()
                self.board.printDescription()
            }
        }
    }
}
