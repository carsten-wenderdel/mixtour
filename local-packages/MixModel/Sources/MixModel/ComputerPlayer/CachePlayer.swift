import Core

/// Remembers all moves it has made.
/// If the human makes an "Undo" and then makes exactly the same move, this class will answer with the same move again.
/// So for new games better create a new instance of this class.
public class CachePlayer: ComputerPlayer {

    let computerPlayer: ComputerPlayer

    var moves = [[Square:[Piece]]: Move]()

    public init(_ computerPlayer: ComputerPlayer) {
        self.computerPlayer = computerPlayer
    }

    public func bestMove(_ board: Board) -> Move? {
        // setPieces defines a board sufficiently to make comparisons for equality.
        // We don't have a function for comparing MIXCoreBoard yet.
        if let move = moves[board.setPieces] {
            return move
        }

        let move = computerPlayer.bestMove(board)
        moves[board.setPieces] = move
        return move
    }
}
