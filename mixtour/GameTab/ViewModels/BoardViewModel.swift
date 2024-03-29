import Foundation
import MixModel

final class BoardViewModel: ObservableObject {

    // MARK: internal types

    enum State {
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

    private struct PickedPieces {
        var square: Square
        var number: Int
    }

    // MARK: variables set from outside
    private var board: Board
    private var humanColor: PlayerColor
    private var computerVM: ComputerPlayerViewModel

    // MARK: internal state, to be observed from outside
    @Published private var state: State
    @Published private var previousBoard: Board?
    @Published private var animatableMove: Move?

    @Published private var pickedPieces: PickedPieces? {
        didSet {
            if pickedPieces != nil {
                animatableMove = nil
            }
        }
    }

    // MARK: internal properties
    private let computerPlayerQueue = DispatchQueue(label: "com.wenderdel.mixtour", qos: .userInitiated)
    private var computerColor: PlayerColor { humanColor == .white ? .black : .white }

    // MARK: public computed properties

    var undoPossible: Bool { previousBoard != nil }
    var gameOver: Bool { board.isGameOver() }

    var interactionDisabled: Bool {
        if gameOver {
            return true
        }
        switch state {
        case .computerTurn:
            return true
        case .humanTurn:
            return false
        }
    }

    var humanHasWon: Bool {
        return gameOver && humanColor == board.winner()
    }

    var computerHasWon: Bool {
        return gameOver && humanColor != board.winner()
    }

    var humanHasWonText: String {
        "Game Over \n\n" + LocalizedString("You have won!")
    }

    var computerHasWonText: String {
        "Game Over \n\n" + LocalizedString("Computer has won")
    }

    var computerPlayerInfo: String {
        return computerVM.description
    }

    // MARK: Initializers

    init(
        board: Board = Board(),
        color: PlayerColor = .white,
        computerVM: ComputerPlayerViewModel
    ) {
        self.board = board
        self.humanColor = color
        self.computerVM = computerVM
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
                computerVM: computerVM
            )
        }
    }

    func reset(board: Board = Board(),
               color: PlayerColor,
               computerVM: ComputerPlayerViewModel
    ) {
        previousBoard = nil
        animatableMove = nil
        pickedPieces = nil
        self.board = board
        self.humanColor = color
        state =
            board.playerOnTurn() == color
            ? .humanTurn(previousMove: nil)
            : .computerTurn(previousMove: nil)
        self.computerVM = computerVM
        if case .computerTurn = state {
            letComputerMakeNextMove()
        }
    }

    func pickPieceFromSquare(_ square: Square) {
        let oldNumber = numberOfPickedPiecesAt(square)
        let number = (oldNumber + 1) % board.heightOfSquare(square)
        pickedPieces = PickedPieces(square: square, number: number)
    }

    func stopPickingOtherThan(_ square: Square) {
        if square != pickedPieces?.square {
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
        previousBoard = Board(board)
        state = .computerTurn(previousMove: move)
        animatableMove = nil
        pickedPieces = nil
        board.makeMoveIfLegal(move)

        if (board.isGameOver()) {
            return
        }

        if computerVM.player is DummyComputerPlayer {
            // Hack so that this function can be unit tested
            return
        }
        letComputerMakeNextMove(waitFor: 0.8)
    }

    /// timeToShowMoveAnimation - we might want to start a bit later to let the user's move animation finish.
    /// If it's zero, the computer's move is shown as early as possible.
    /// If it's 1, and the computer takes 1.1 seconds to think, the move is shown directly after 1.1 seconds.
    private func letComputerMakeNextMove(waitFor seconds: Double = 0.0) {
        let timeToShowMoveAnimation: DispatchTime = .now() + DispatchTimeInterval.milliseconds(Int(1000*seconds))
        // The computer move might be generated a few seconds later. Maybe the user has
        // undone a move, in this case the computer move must not be applied. So we need
        // to remember the board state.
        let computerMoveBoard = Board(board)
        computerPlayerQueue.async {
            // We always call bestMove(:) on the same queue, so never two calls in parallel.
            let move = self.computerVM.player.bestMove(self.board)
            DispatchQueue.main.asyncAfter(deadline: timeToShowMoveAnimation) { [weak self] in
                guard let self = self else { return }
                guard computerMoveBoard == self.board else {
                    // User has restarted the game or undone a move, so we don't need this computer move.
                    return
                }
                guard let move = move else {
                    assertionFailure("Move is nil, this should not happen")
                    return
                }
                self.state = .humanTurn(previousMove:move)
                self.animatableMove = move
                self.board.makeMoveIfLegal(move)
            }
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
            square: Square(column: 6, line: 6)
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
            square: square
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
        if case let .computerTurn(previousMove) = state {
            if case let .set(square) = previousMove, square[keyPath: keyPath] == value {
                // The human player just has set this piece. The zIndex needs to be high, so that during the animation from outside it's not hidden underneath other stacks. See unit tests for details.
                return 4
            }
        }
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
        reset(
            color: .white,
            computerVM: ComputerPlayerViewModel(config: .beginner1)
        )
        makeComputerMove()
    }

    private func makeComputerMove() {
        objectWillChange.send()
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
