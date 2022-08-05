import Foundation
import Core


extension MIXCoreBoard {
    static func new() -> MIXCoreBoard {
        var coreBoard = MIXCoreBoard()
        resetCoreBoard(&coreBoard)
        return coreBoard
    }

    func printDescription() {
        var state = self
        Core.printBoardDescription(&state)
    }
}


public final class Board {
    
    var coreBoard: MIXCoreBoard
    var setPieces: [Square:[Piece]]
    var unusedPieces: [PlayerColor:[Piece]]

    public init() {
        coreBoard = .new()
        setPieces = [:]
        unusedPieces = [.white:[], .black:[]]
        for player: PlayerColor in [.white, .black] {
            for i in 0..<numberOfPiecesForPlayer(player) {
                // black and white pieces need different ids, so let them be 100 apart, but could be any number bigger than 20
                let piece = Piece(
                    color: player,
                    id: 100 * player.rawValue + i
                )
                unusedPieces[player]!.append(piece)
            }
        }
    }
    
    public init(_ board: Board) {
        coreBoard = board.coreBoard
        setPieces = board.setPieces
        unusedPieces = board.unusedPieces
    }

    public func isGameOver() -> Bool {
        return Core.isGameOver(&coreBoard)
    }

    public func isGameDraw() -> Bool {
        return Core.isGameDraw(&coreBoard)
    }

    public func winner() -> PlayerColor? {
        let corePlayer = Core.winner(&coreBoard)
        return PlayerColor(corePlayer: corePlayer)
    }
    
    public func playerOnTurn() -> PlayerColor {
        let corePlayer = Core.playerOnTurn(&coreBoard)
        return PlayerColor(corePlayer: corePlayer)!
    }
    
    public func numberOfPiecesForPlayer(_ player: PlayerColor) -> Int {
        return Int(Core.numberOfPiecesForPlayer(&coreBoard, player.corePlayer()))
    }
    
    func isSquareEmpty(_ square: Square) -> Bool {
        return Core.isSquareEmpty(&coreBoard, square.coreSquare())
    }
    
    public func heightOfSquare(_ square: Square) -> Int {
        return Int(Core.heightOfSquare(&coreBoard, square.coreSquare()))
    }
    
    /// position 0 is the upper most piece. Undefined behavior for not existing pieces
    public func colorOfSquare(_ square: Square, atPosition position: Int) -> PlayerColor{
        let corePlayer = colorOfSquareAtPosition(&coreBoard, square.coreSquare(), UInt8(position))
        return PlayerColor(corePlayer: corePlayer)!
    }

    /// position 0 is the upper most piece
    public func piecesAtSquare(_ square: Square) -> [Piece] {
        return setPieces[square] ?? []
    }

    public func unusedPiecesForPlayer(_ player: PlayerColor) -> [Piece] {
        return unusedPieces[player]!
    }
    
    /**
    If this is a legal move, it returns YES.
    If it's an illegal move, the move is not made and NO is returned. The model is still fine.
    */
    @discardableResult public func setPiece(_ square: Square) -> Bool {
        let move = Move.set(to: square)
        return makeMoveIfLegal(move)
    }
    

    @discardableResult func dragPiecesFrom(_ from: Square, to: Square, withNumber numberODraggedPieces: Int) -> Bool {
        let modelMove = Move.drag(from: from, to: to, numberOfPieces: numberODraggedPieces)
        return makeMoveIfLegal(modelMove)
    }

    @discardableResult public func makeMoveIfLegal(_ move: Move) -> Bool {
        guard isMoveLegal(move) else {
            return false
        }

        switch move {
        case .drag(let from, let to, let numberOfPieces):
            var fromArray = setPieces[from]! // If there are bugs I want to know them - crash!
            var toArray = setPieces[to]!
            toArray.insert(contentsOf: fromArray.prefix(numberOfPieces), at: 0)
            fromArray.removeFirst(numberOfPieces)
            setPieces[from] = fromArray
            setPieces[to] = toArray
        case .set(let to):
            setPieces[to] = [unusedPieces[playerOnTurn()]!.removeLast()]
        case .pass:
            break
        }

        Core.makeMove(&coreBoard, move.coreMove())
        return true
    }

    public func isMoveLegal(_ move: Move) -> Bool {
        return Core.isMoveLegal(&coreBoard, move.coreMove())
    }

    func isSettingPossible() -> Bool {
        return Core.isSettingPossible(&coreBoard)
    }

    func isDraggingPossible() -> Bool {
        return Core.isDraggingPossible(&coreBoard)
    }

    func sensibleMoves() -> [Move] {
        var moveBuffer = Core.newMoveArray()
        let moveArray = Self.sensibleMoves(&coreBoard, moveBuffer: &moveBuffer)
        Core.destroyMoveArray(moveBuffer)
        return moveArray.map { Move($0) }
    }

    static func sensibleMoves(
        _ coreBoard: inout MIXCoreBoard,
        moveBuffer: inout MIXMoveArray
    ) -> ContiguousArray<MIXCoreMove> {
        Core.sensibleMoves(&coreBoard, &moveBuffer)
        let buffer = UnsafeBufferPointer(start: moveBuffer.a, count: moveBuffer.n)
        let moveArray = ContiguousArray(buffer)
        return moveArray
    }
    
    public func printDescription() -> Void {
        printBoardDescription(&coreBoard);
    }
}

extension Board: Equatable {
    public static func == (lhs: Board, rhs: Board) -> Bool {
        lhs.setPieces == rhs.setPieces
    }
}
