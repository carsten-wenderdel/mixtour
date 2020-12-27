import Core

/// Not to be used in normal play but for creating game situations quickly (for example in unit tests)
extension ModelBoard {

    public static var example: ModelBoard {
        let board = ModelBoard()
//        board.setPiecesDirectlyToSquare(ModelSquare(column: 2, line: 4), .black, .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 3, line: 2), .white, .white, .black)
//        board.setPiecesDirectlyToSquare(ModelSquare(column: 4, line: 4), .black)
        return board
    }
    
    func setPiecesDirectlyToSquare(_ square: ModelSquare, _ args: ModelPlayer...) {
        var id = numberOfPiecesForPlayer(.black) + numberOfPiecesForPlayer(.white)
        var pieceArray = [ModelPiece]()
        for modelPlayer in args {
            pieceArray.insert(ModelPiece(color: modelPlayer, id: id), at: 0)
            id -= 1
        }
        pieces[square] = pieceArray

        var corePlayers: [CVarArg] = [CVarArg]()
        for modelPlayer in args {
            corePlayers.append(modelPlayer.rawValue)
        }
        Core.setPiecesDirectlyWithList(&coreBoard, square.coreSquare(), Int32(corePlayers.count), getVaList(corePlayers))
    }
    
    func setTurnDirectly(_ player: ModelPlayer) {
        Core.setTurnDirectly(&coreBoard, player.corePlayer())
    }
}
