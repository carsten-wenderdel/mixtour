import XCTest
@testable import MixModel

class ModelBoardTests : XCTestCase {
    
    func testInit() {
        let modelBoard = ModelBoard()
        
        XCTAssertEqual(modelBoard.playerOnTurn(), ModelPlayer.white, "White should start game")
        XCTAssertEqual(modelBoard.numberOfPiecesForPlayer(ModelPlayer.white), 20, "20 pieces at the start")
        XCTAssertEqual(modelBoard.numberOfPiecesForPlayer(ModelPlayer.black), 20, "20 pieces at the start")
        
        for i in 0..<5 {
            for j in 0..<5 {
                let square = Square(column: i, line: j)
                XCTAssertTrue(modelBoard.isSquareEmpty(square), "at the the start everything is empty")
                XCTAssertEqual(modelBoard.heightOfSquare(square), 0, "at the start everything should be empty")
            }
        }
    }
    
    
    func testInitWithBoard() {
        // given
        let modelBoard = ModelBoard();
        let modelSquare = Square(column: 1, line: 1)
        modelBoard.makeMoveIfLegal(Move(setPieceTo: modelSquare))
        
        // when
        let copyBoard = ModelBoard(board: modelBoard)
        
        // assert
        XCTAssertEqual(copyBoard.heightOfSquare(modelSquare), 1)
        
        // when
        let modelSquare2 = Square(column: 2, line: 2)
        copyBoard.makeMoveIfLegal(Move(setPieceTo: modelSquare2))

        // assert
        XCTAssertEqual(copyBoard.heightOfSquare(modelSquare2), 1)
        XCTAssertEqual(modelBoard.heightOfSquare(modelSquare2), 0)
    }
    
    func testGameOver() {
        let board = ModelBoard()
        XCTAssertFalse(board.isGameOver(), "")
        
        board.setPiece(Square(column: 0, line: 0))
        for i in 1..<5 {
            XCTAssertFalse(board.isGameOver(), "")
            let oldSquare = Square(column: 0, line: i - 1)
            let newSquare = Square(column: 0, line: i)
            board.setPiece(newSquare)
            board.dragPiecesFrom(oldSquare, to: newSquare, withNumber: i)
        }
        XCTAssertTrue(board.isGameOver(), "")
        XCTAssertFalse(board.isMoveLegal(Move(setPieceTo: .init(column: 3, line: 0))))
    }
    
    
    func testWinner() {
        var board = ModelBoard()
        XCTAssertEqual(board.winner(), nil)
        
        board.setPiece(Square(column: 0, line: 0))
        for i in 1..<5 {
            XCTAssertEqual(board.winner(), nil)
            let oldSquare = Square(column: 0, line: i - 1)
            let newSquare = Square(column: 0, line: i)
            board.setPiece(newSquare)
            board.dragPiecesFrom(oldSquare, to:newSquare, withNumber:i)
        }
        
        XCTAssertEqual(board.winner(), ModelPlayer.white)
        
        // and now the same, but place one additional piece at the beginning somewhere else.
        board = ModelBoard()
        board.setPiece(Square(column: 3, line: 3))
        board.setPiece(Square(column: 0, line: 0))
        for i in 1..<5 {
            let oldSquare = Square(column: 0, line: i - 1)
            let newSquare = Square(column: 0, line: i)
            board.setPiece(newSquare)
            board.dragPiecesFrom(oldSquare, to:newSquare, withNumber:i)
        }
        
        XCTAssertEqual(board.winner(), ModelPlayer.black)
    }
    
    
    func testPlayerOnTurn() {
        let board = ModelBoard()
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.white)
        
        board.setPiece(Square(column: 1, line: 1))
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.black)
        
        board.setPiece(Square(column: 1, line: 2))
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.white)
        
        board.setPiece(Square(column: 2, line: 2))
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.black)
        
        board.dragPiecesFrom(Square(column: 1, line: 1), to:Square(column: 1, line: 2), withNumber:1)
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.white)
        
        board.dragPiecesFrom(Square(column: 2, line: 2), to:Square(column: 1, line: 2), withNumber:1)
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.white, "illegal move, turn stays")
        
        board.dragPiecesFrom(Square(column: 1, line: 2), to:Square(column: 2, line: 2), withNumber:1)
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.black)
    }
    
    func testSetPiece() {
        let board = ModelBoard()
        
        let square1 = Square(column: 1, line: 3)
        let square2 = Square(column: 2, line: 3)
        let square3 = Square(column: 3, line: 3)
        
        XCTAssertTrue(board.setPiece(square1), "this should be empty and therefore legal")
        XCTAssertTrue(board.setPiece(square2), "this should be empty and therefore legal")
        XCTAssertFalse(board.setPiece(square1), "There should already be a piece")
        XCTAssertTrue(board.setPiece(square3), "this should be empty and therefore legal")
        
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.white), 18, "two pieces set")
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.black), 19,
            "only one piece set, one move attempt was illegal")
        
        XCTAssertEqual(board.heightOfSquare(square2), 1, "one piece set -> height 1")
        XCTAssertEqual(board.heightOfSquare(square1), 1, "you can only set once -> height 1")
        XCTAssertEqual(board.heightOfSquare(Square(column: 0, line: 0)), 0, "nothing set here")
    }
    
    
    func testColorOfSquare() {
        
        let board = ModelBoard()
        
        let square0 = Square(column: 0, line: 3)
        let square1 = Square(column: 1, line: 3)
        let square2 = Square(column: 2, line: 3)
        let square3 = Square(column: 3, line: 3)
        let square4 = Square(column: 4, line: 3)

        board.setPiece(square0) // white
        board.setPiece(square1) // black
        board.setPiece(square2) // white
        board.setPiece(square3) // black
        board.setPiece(square4) // white
        
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:0), ModelPlayer.white)
        XCTAssertEqual(board.colorOfSquare(square1, atPosition:0), ModelPlayer.black)
        XCTAssertEqual(board.colorOfSquare(square2, atPosition:0), ModelPlayer.white)
        XCTAssertEqual(board.colorOfSquare(square3, atPosition:0), ModelPlayer.black)
        XCTAssertEqual(board.colorOfSquare(square4, atPosition:0), ModelPlayer.white)
        
        board.dragPiecesFrom(square1, to:square0, withNumber:1)
        board.dragPiecesFrom(square4, to:square3, withNumber:1)
        board.dragPiecesFrom(square3, to:square2, withNumber:2)
        board.dragPiecesFrom(square2, to:square0, withNumber:2) // not all!
        
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:3), ModelPlayer.white, "here from the beginning")
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:2), ModelPlayer.black, "originally at square1")
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:1), ModelPlayer.black, "originally at square3")
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:0), ModelPlayer.white, "originally at square4")
        XCTAssertEqual(board.colorOfSquare(square2, atPosition:0), ModelPlayer.white, "here from the beginning")
    }

    /// Also tests correct id for both setting and dragging
    func testPiecesAtSquare() {
        // Given
        let square0 = Square(column: 0, line: 3)
        let square1 = Square(column: 1, line: 3)

        let board = ModelBoard()

        // When
        board.setPiece(square0)
        var pieces = board.piecesAtSquare(square0)

        // Then
        XCTAssertEqual(pieces, [Piece(color: .white, id: 19)])

        // And When
        board.setPiece(square1)
        board.dragPiecesFrom(square0, to: square1, withNumber: 1)
        pieces = board.piecesAtSquare(square1)
        let noPieces = board.piecesAtSquare(square0)

        // Then
        XCTAssertEqual(pieces, [Piece(color: .white, id: 19), Piece(color: .black, id: 119)])
        XCTAssertEqual(noPieces, [])
        XCTAssert(board.unusedPiecesForPlayer(.black).filter{ $0.id == 119}.isEmpty)
        XCTAssert(board.unusedPiecesForPlayer(.white).filter{ $0.id == 19}.isEmpty)
        XCTAssert(board.unusedPiecesForPlayer(.white).count == 19)
        XCTAssert(board.unusedPiecesForPlayer(.black).count == 19)
    }

    func testDragsTheRightIDWhenLargerStack() {
        // Given
        let square0 = Square(column: 0, line: 1)
        let square1 = Square(column: 2, line: 1)
        let board = ModelBoard()

        board.setPiecesDirectlyToSquare(square0, .black, .white)
        board.setPiecesDirectlyToSquare(square1, .black, .white)

        let upperMostId0 = board.piecesAtSquare(square0).first!.id
        let upperMostId1 = board.piecesAtSquare(square1).first!.id

        // When
        board.dragPiecesFrom(square0, to: square1, withNumber: 1)

        // Then
        let newId0 = board.piecesAtSquare(square0).first!.id
        let newId1 = board.piecesAtSquare(square1).first!.id

        XCTAssertEqual(upperMostId0, newId1)
        XCTAssertNotEqual(upperMostId0, newId0)
        XCTAssertNotEqual(upperMostId1, newId1)
        XCTAssertNotEqual(upperMostId1, newId0)
    }
    
    func boardForTestingMoves() -> ModelBoard {
        
        let board = ModelBoard()
        
        // from top to bottom: black, white, white on 1/1
        board.setPiece(Square(column: 1, line: 1))
        board.setPiece(Square(column: 0, line: 1))
        board.setPiece(Square(column: 0, line: 0))
        board.dragPiecesFrom(Square(column: 0, line: 1), to:Square(column: 0, line: 0), withNumber:1)
        board.dragPiecesFrom(Square(column: 0, line: 0), to:Square(column: 1, line: 1), withNumber:2)
        
        // from top to bottom: white, black, black on 4/4
        board.setPiece(Square(column: 4, line: 4))
        board.setPiece(Square(column: 2, line: 4))
        board.setPiece(Square(column: 3, line: 4))
        board.dragPiecesFrom(Square(column: 2, line: 4), to:Square(column: 3, line: 4), withNumber:1)
        board.dragPiecesFrom(Square(column: 3, line: 4), to:Square(column: 4, line: 4), withNumber:2)
        
        // from top to bottom: black, white on 1/4
        board.setPiece(Square(column: 1, line: 4))
        board.setPiece(Square(column: 2, line: 4))
        board.dragPiecesFrom(Square(column: 2, line: 4), to:Square(column: 1, line: 4), withNumber:1)
        
        // white on 0/0
        board.setPiece(Square(column: 0, line: 0))
        
        // black on 0/1
        board.setPiece(Square(column: 0, line: 1))
        
        return board;
    }
    
    
    func testHeight() {
        
        let board = boardForTestingMoves()
        
        XCTAssertEqual(board.heightOfSquare(Square(column: 1, line: 1)), 3)
        XCTAssertEqual(board.heightOfSquare(Square(column: 4, line: 4)), 3)
        XCTAssertEqual(board.heightOfSquare(Square(column: 1, line: 4)), 2)
        XCTAssertEqual(board.heightOfSquare(Square(column: 0, line: 0)), 1)
        XCTAssertEqual(board.heightOfSquare(Square(column: 3, line: 3)), 0, "nothing set here")
    }
    
    
    func testIsDragLegal() {
        
        let board = boardForTestingMoves()
        
        // legal drags:
        XCTAssert(board.isMoveLegal(Move(from: Square(column: 4, line: 4), to:Square(column: 1, line: 1), numberOfPieces: 1)))
        XCTAssert(board.isMoveLegal(Move(from: Square(column: 1, line: 1), to:Square(column: 4, line: 4), numberOfPieces: 1)))
        XCTAssert(board.isMoveLegal(Move(from: Square(column: 1, line: 4), to:Square(column: 1, line: 1), numberOfPieces: 1)))
        XCTAssert(board.isMoveLegal(Move(from: Square(column: 1, line: 4), to:Square(column: 4, line: 4), numberOfPieces: 1)))
        XCTAssert(board.isMoveLegal(Move(from: Square(column: 1, line: 1), to:Square(column: 0, line: 1), numberOfPieces: 1)))
        XCTAssert(board.isMoveLegal(Move(from: Square(column: 1, line: 1), to:Square(column: 0, line: 0), numberOfPieces: 1)))
        
        // illegal drags because of wrong height:
        XCTAssertFalse(board.isMoveLegal(Move(from: Square(column: 1, line: 1), to:Square(column: 1, line: 4), numberOfPieces: 1)))
        XCTAssertFalse(board.isMoveLegal(Move(from: Square(column: 4, line: 4), to:Square(column: 1, line: 4), numberOfPieces: 1)))
        XCTAssertFalse(board.isMoveLegal(Move(from: Square(column: 0, line: 0), to:Square(column: 1, line: 1), numberOfPieces: 1)))
        
        // put some pieces between -> legal becomes illegal
        board.setPiece(Square(column: 2, line: 2))
        XCTAssertFalse(board.isMoveLegal(Move(from: Square(column: 4, line: 4), to:Square(column: 1, line: 1), numberOfPieces: 1)))
        XCTAssertFalse(board.isMoveLegal(Move(from: Square(column: 1, line: 1), to:Square(column: 4, line: 4), numberOfPieces: 1)))
        
        board.setPiece(Square(column: 1, line: 3))
        board.setPiece(Square(column: 3, line: 4))
        XCTAssert(board.isMoveLegal(Move(from: Square(column: 1, line: 4), to:Square(column: 1, line: 1), numberOfPieces: 1)))
        XCTAssert(board.isMoveLegal(Move(from: Square(column: 1, line: 4), to:Square(column: 4, line: 4), numberOfPieces: 1)))
    }
    
    func testMoveIsIllegalIfRevert() {
        let board = ModelBoard()
        
        // given
        let square1 = Square(column: 1, line: 1)
        let square2 = Square(column: 2, line: 2)
        board.setPiecesDirectlyToSquare(square1, .black, .white)
        board.setPiecesDirectlyToSquare(square2, .black)

        // when
        XCTAssert(board.makeMoveIfLegal(Move(from: square1, to: square2, numberOfPieces: 1)))
        
        // then
        XCTAssertFalse(board.isMoveLegal(Move(from: square2, to: square1, numberOfPieces: 1)))
    }

    func testDragWithZeroPiecesIsIllegal() {
        // Given
        let board = ModelBoard()

        let square1 = Square(column: 1, line: 1)
        let square2 = Square(column: 2, line: 2)
        board.setPiecesDirectlyToSquare(square1, .white)

        // When / Then
        XCTAssertFalse(board.isMoveLegal(Move(from: square2, to: square1, numberOfPieces: 0)))
    }

    func testIsDraggingLegalCross() {
        let board = ModelBoard()
        for i in 1..<5 {
            for j in 1..<5 {
                board.setPiece(Square(column: i, line: j))
            }
        }
        let squareWithTwoPieces = Square(column: 4, line: 1)
        board.dragPiecesFrom(Square(column: 3, line: 2), to:squareWithTwoPieces, withNumber:1)
        
        XCTAssertTrue(board.isMoveLegal(Move(from: Square(column: 2, line: 3), to: squareWithTwoPieces, numberOfPieces: 1)))
    }
    
    func testIsSettingPossible() {
        
        let board = ModelBoard()
        
        // setting pieces everywhere
        for i in 0..<5 {
            for j in 0..<5 {
                XCTAssertTrue(board.isSettingPossible(), "still something free")
                board.setPiece(Square(column: i, line: j))
            }
        }
        XCTAssertFalse(board.isSettingPossible(), "all 25 squares covered")
        
        // clearing (15) squares as much as possible with the exception of j==0
        for i in 0..<5 {
            for j in 1..<4 {
                let from = Square(column: i, line: j)
                let to = Square(column: i, line: j+1)
                board.dragPiecesFrom(from, to:to, withNumber:j)
                XCTAssertTrue(board.isSettingPossible(), "")
            }
        }
        
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.white), 7, "")
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.black), 8, "")
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.white)
        
        // setting 14 pieces on cleared squares
        for i in 0..<5 {
            for j in 1..<4 {
                if (i != 4 || j != 3) {
                    XCTAssertTrue(board.isSettingPossible(), "")
                    let square = Square(column: i, line: j)
                    XCTAssertTrue(board.isSquareEmpty(square))
                    board.setPiece(square)
                }
            }
        }
        
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.white), 0, "")
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.black), 1, "")
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.white)
        
        let emptySquare = Square(column: 4, line: 3)
        XCTAssertTrue(board.isSquareEmpty(emptySquare))
        XCTAssertFalse(board.isSettingPossible(), "no pieces left for white")
        
        board.dragPiecesFrom(Square(column: 1, line: 4), to:Square(column: 1, line: 3), withNumber:3)
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.black)
        XCTAssertTrue(board.isSettingPossible(), "")
        board.setPiece(emptySquare)
        
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.white)
        XCTAssertFalse(board.isSettingPossible(), "")
        board.dragPiecesFrom(Square(column: 1, line: 3), to:Square(column: 1, line: 4), withNumber:3)
        
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.black)
        XCTAssertFalse(board.isSettingPossible(), "no pieces left for black")
    }
    
    func testDraggingNotPossibleForEmptyBoard() {
        let board = ModelBoard()
        XCTAssertFalse(board.isDraggingPossible())
    }
    
    func testDraggingPossibleLeft() {
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 0), .black, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 0), .black, .white)
        XCTAssertTrue(board.isDraggingPossible())
        
        // In between:
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 0), .white, .black)
        XCTAssertFalse(board.isDraggingPossible())
    }
    
    func testDraggingPossibleRight() {
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 0), .black, .black)
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 0), .black, .white, .black)
        XCTAssertTrue(board.isDraggingPossible())
        
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 0), .white, .white, .white)
        XCTAssertFalse(board.isDraggingPossible())
    }
    
    func testDraggingPossibleUp() {
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 1), .black, .white, .black)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 0), .black)
        XCTAssertTrue(board.isDraggingPossible())
    }
    
    func testDraggingPossibleDown() {
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 0), .black, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 4), .black, .white, .black, .white)
        XCTAssertTrue(board.isDraggingPossible())
        
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 3), .white, .black)
        XCTAssertFalse(board.isDraggingPossible())
    }
    
    func testDraggingPossibleLeftUp() {
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 4), .black, .white, .black, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 2), .black, .white)
        XCTAssertTrue(board.isDraggingPossible())
        
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 3), .white, .black)
        XCTAssertFalse(board.isDraggingPossible())
    }
    
    func testDraggingPossibleLeftDown() {
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 0), .black, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 2), .black, .white)
        XCTAssertTrue(board.isDraggingPossible())
        
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 1), .white, .black)
        XCTAssertFalse(board.isDraggingPossible())
    }
    
    func testDraggingPossibleRightUp() {
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 4), .black)
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 1), .black, .white, .black)
        XCTAssertTrue(board.isDraggingPossible())
        
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 2), .white, .white, .black)
        XCTAssertFalse(board.isDraggingPossible())
    }
    
    func testDraggingPossibleRightDown() {
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 0), .black, .white)
        board.setPiecesDirectlyToSquare(Square(column: 4, line: 3), .black, .white, .black)
        XCTAssertTrue(board.isDraggingPossible())
        
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 1), .white, .black, .black)
        XCTAssertFalse(board.isDraggingPossible())
    }
    
    func testNumberOfMovesIs25ForEmptyBoard() {
        let board = ModelBoard()
        let allMoves = board.allLegalMoves()
        XCTAssertEqual(allMoves.count, 25)
    }
    
    func testLegalMovesDoesNotContainRevertMove() {
        let board = ModelBoard()
        
        let square1 = Square(column: 1, line: 0)
        let square2 = Square(column: 1, line: 1)
        
        board.setPiecesDirectlyToSquare(square1, .black, .white, .white)
        board.setPiecesDirectlyToSquare(square2, .black)

        var allMoves = board.allLegalMoves()
        XCTAssertEqual(allMoves.count, 26)
        for move in allMoves {
            XCTAssert(board.isMoveLegal(move))
        }
        
        board.makeMoveIfLegal(Move(from: square1, to: square2, numberOfPieces: 2))
        
        allMoves = board.allLegalMoves()
        XCTAssertEqual(allMoves.count, 25)
        for move in allMoves {
            XCTAssert(board.isMoveLegal(move))
        }
    }
    
    func testNumberOfMovesIsZeroIfNoPiecesAvailable() {
        let board = ModelBoard()
    
        // given all 20 white pieces are set:
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 0), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 1), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 2), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 3), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 4), .white, .white, .white, .white)

        let allMovesForWhite = board.allLegalMoves()
        XCTAssertEqual(allMovesForWhite.count, 0)
        
        // given no white piece is set and 20 tiles are free
        board.setTurnDirectly(.black)
        
        let allMovesForBlack = board.allLegalMoves()
        XCTAssertEqual(allMovesForBlack.count, 20)
        for move in allMovesForBlack {
            XCTAssertFalse(move.isMoveDrag())
        }
    }
    
    func testNumberOfMovesForComplicatedPosition() {
        let board = ModelBoard()
        
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 0), .white, .black, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 4, line: 4), .white, .black)
        
        let allMoves = board.allLegalMoves()
        // 23 sets and 1 drag
        XCTAssertEqual(allMoves.count, 25)
        XCTAssertTrue(allMoves.contains(Move(setPieceTo: Square(column: 2, line: 2))))
        
        let someDragMove = Move(from: Square(column: 4, line: 4), to: Square(column: 0, line: 0), numberOfPieces: 2)
        XCTAssertTrue(allMoves.contains(someDragMove))
    }
}

