import Foundation
import Core

// TODO: move it into some class or enum?
public let numberOfSquares = 5


public class ModelBoard {
    
    var coreBoard: MIXCoreBoard
    var setPieces: [ModelSquare:[ModelPiece]]
    var unusedPieces: [ModelPlayer:[ModelPiece]]

    public init() {
        coreBoard = MIXCoreBoard()
        resetCoreBoard(&coreBoard)
        setPieces = [:]
        unusedPieces = [.white:[], .black:[]]
        for player: ModelPlayer in [.white, .black] {
            for i in 0..<numberOfPiecesForPlayer(player) {
                // black and white pieces need different ids, so let them be 100 apart, but could be any number bigger than 20
                let piece = ModelPiece(
                    color: player,
                    id: 100 * player.rawValue + i
                )
                unusedPieces[player]!.append(piece)
            }
        }
    }
    
    public init(board: ModelBoard) {
        coreBoard = board.coreBoard
        setPieces = board.setPieces
        unusedPieces = board.unusedPieces
    }

    public func isGameOver() -> Bool {
        return Core.isGameOver(&coreBoard)
    }

    public func winner() -> ModelPlayer? {
        let corePlayer = Core.winner(&coreBoard)
        return ModelPlayer(corePlayer: corePlayer)
    }
    
    public func playerOnTurn() -> ModelPlayer {
        let corePlayer = Core.playerOnTurn(&coreBoard)
        return ModelPlayer(corePlayer: corePlayer)!
    }
    
    public func numberOfPiecesForPlayer(_ player: ModelPlayer) -> Int {
        return Int(Core.numberOfPiecesForPlayer(&coreBoard, player.corePlayer()))
    }
    
    func isSquareEmpty(_ square: ModelSquare) -> Bool {
        return Core.isSquareEmpty(&coreBoard, square.coreSquare())
    }
    
    public func heightOfSquare(_ square: ModelSquare) -> Int {
        return Int(Core.heightOfSquare(&coreBoard, square.coreSquare()))
    }
    
    /// position 0 is the upper most piece. Undefined behavior for not existing pieces
    public func colorOfSquare(_ square: ModelSquare, atPosition position: Int) -> ModelPlayer{
        let corePlayer = colorOfSquareAtPosition(&coreBoard, square.coreSquare(), UInt8(position))
        return ModelPlayer(corePlayer: corePlayer)!
    }

    /// position 0 is the upper most piece
    public func piecesAtSquare(_ square: ModelSquare) -> [ModelPiece] {
        return setPieces[square] ?? []
    }

    public func unusedPiecesForPlayer(_ player: ModelPlayer) -> [ModelPiece] {
        return unusedPieces[player]!
    }
    
    /**
    If this is a legal move, it returns YES.
    If it's an illegal move, the move is not made and NO is returned. The model is still fine.
    */
    @discardableResult public func setPiece(_ square: ModelSquare) -> Bool {
        let move = ModelMove(setPieceTo: square)
        return makeMoveIfLegal(move)
    }
    

    @discardableResult func dragPiecesFrom(_ from: ModelSquare, to: ModelSquare, withNumber numberODraggedPieces: Int) -> Bool {
        let modelMove = ModelMove(from: from, to: to, numberOfPieces: numberODraggedPieces)
        return makeMoveIfLegal(modelMove)
    }

    @discardableResult public func makeMoveIfLegal(_ move: ModelMove) -> Bool {
        guard isMoveLegal(move) else {
            return false
        }

        if move.isMoveDrag() {
            var fromArray = setPieces[move.from]! // If there are bugs I want to know them - crash!
            var toArray = setPieces[move.to]!
            toArray.insert(contentsOf: fromArray.prefix(move.numberOfPieces), at: 0)
            fromArray.removeFirst(move.numberOfPieces)
            setPieces[move.from] = fromArray
            setPieces[move.to] = toArray
        } else {
            // again - if something is nil, "isMoveLegal" should have found it.
            setPieces[move.to] = [unusedPieces[playerOnTurn()]!.removeLast()]
        }

        Core.makeMove(&coreBoard, move.coreMove())
        return true
    }

    public func isMoveLegal(_ move: ModelMove) -> Bool {
        return Core.isMoveLegal(&coreBoard, move.coreMove())
    }

    func isSettingPossible() -> Bool {
        return Core.isSettingPossible(&coreBoard)
    }

    func isDraggingPossible() -> Bool {
        return Core.isDraggingPossible(&coreBoard)
    }

    func isSettingOrDraggingPossbile() -> Bool {
        return true
    }

    func allLegalMoves() -> [ModelMove] {
        var swiftMoves = [ModelMove]()
        let cMoves = Core.arrayOfLegalMoves(&coreBoard)
        for i in 0..<cMoves.n {
            let coreMove = cMoves.a[i]
            swiftMoves.append(ModelMove(coreMove: coreMove))
        }
        Core.destroyMoveArray(cMoves)
        return swiftMoves
    }
    
    
    public func bestMove() -> ModelMove? {
        let move = Core.bestMove(&coreBoard)
        if Core.isMoveANoMove(move) {
            return nil
        } else {
            return ModelMove(coreMove: move)
        }
    }
    
    func printDescription() -> Void {
        printBoardDescription(&coreBoard);
    }
}
