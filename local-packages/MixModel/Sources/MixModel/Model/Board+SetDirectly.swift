import Core

/// Not to be used in normal play but for creating game situations quickly (for example in unit tests)
extension Board {

    /// First player argument is at the bottom, last at the top of the stack.
    func setPiecesDirectlyToSquare(_ square: Square, _ args: PlayerColor...) {
        var corePlayers: [CVarArg] = [CVarArg]()
        var pieceStack = [Piece]()
        for modelPlayer in args {
            corePlayers.append(modelPlayer.rawValue)
            pieceStack.insert(unusedPieces[modelPlayer]!.removeLast(), at: 0)
        }

        setPieces[square] = pieceStack
        Core.setPiecesDirectlyWithList(&coreBoard, square.coreSquare(), Int32(corePlayers.count), getVaList(corePlayers))
    }
    
    func setTurnDirectly(_ player: PlayerColor) {
        Core.setTurnDirectly(&coreBoard, player.corePlayer())
    }
}

/// Some preconfigured board situations
extension Board {

    public static var example: Board {
        let board = Board()
//        board.setPiecesDirectlyToSquare(ModelSquare(column: 2, line: 4), .black, .white)
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 2), .white, .white, .black)
//        board.setPiecesDirectlyToSquare(ModelSquare(column: 4, line: 4), .black)
        return board
    }

    public static var noMovePossible: Board {
        let board = Board()
        for line in 0..<5 {
            board.setPiecesDirectlyToSquare(Square(column: 1, line: line), .white, .white, .white, .white)
            board.setPiecesDirectlyToSquare(Square(column: 3, line: line), .black, .black, .black, .black)
        }
        return board
    }

    public static var whiteCanMoveBlackCant: Board {
        let board = Board()
        for line in 0..<5 {
            board.setPiecesDirectlyToSquare(Square(column: 0, line: line), .white, .white, .white)
            board.setPiecesDirectlyToSquare(Square(column: 1, line: line), .black, .black, .black, .black)
        }
        return board
    }
}
