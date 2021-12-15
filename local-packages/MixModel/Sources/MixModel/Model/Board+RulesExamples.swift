import Core

/// Board situations that are used in the examples given in https://spielstein.com/games/mixtour/rules
extension Board {

    public static var figure1: Board {
        let board = Board()
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 1), .white, .white, .black)
        board.setPiecesDirectlyToSquare(Square(column: 4, line: 1), .white, .black)
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 2), .white)
        board.setPiecesDirectlyToSquare(Square(column: 4, line: 4), .black, .white)
        return board
    }

    public static var figure2: Board {
        let board = Board()
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 1), .black, .black, .black)
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 2), .black, .white, .black)
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 2), .white)
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 2), .white)
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 3), .white, .black)
        return board
    }
}
