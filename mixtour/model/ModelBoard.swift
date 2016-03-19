//
//  ModelBoard.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 24/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation


let numberOfSquares = 5


class ModelBoard {
    
    var coreBoard = MIXCoreBoard()
    
    init() {
        resetCoreBoard(&coreBoard)
    }
    
    func isGameOver() -> Bool {
        return mixtour.isGameOver(&coreBoard)
    }
    
    
    func winner() -> ModelPlayer {
        let corePlayer = mixtour.winner(&coreBoard)
        return mixtour.ModelPlayer(corePlayer: corePlayer)
    }
    
    
    func playerOnTurn() -> ModelPlayer {
        let corePlayer = mixtour.playerOnTurn(&coreBoard)
        return mixtour.ModelPlayer(corePlayer: corePlayer)
    }
    
    
    func numberOfPiecesForPlayer(player: ModelPlayer) -> Int {
        return Int(mixtour.numberOfPiecesForPlayer(&coreBoard, player.corePlayer()))
    }
    
    
    func isSquareEmpty(square: ModelSquare) -> Bool {
        return mixtour.isSquareEmpty(&coreBoard, square.coreSquare())
    }
    
    
    func heightOfSquare(square: ModelSquare) -> Int {
        return Int(mixtour.heightOfSquare(&coreBoard, square.coreSquare()))
    }
    
    
    func colorOfSquare(square: ModelSquare, atPosition position: Int) -> ModelPlayer{
        let corePlayer = colorOfSquareAtPosition(&coreBoard, square.coreSquare(), UInt8(position))
        return mixtour.ModelPlayer(corePlayer: corePlayer)
    }
    
    
    /**
    If this is a legal move, it returns YES.
    If it's an illegal move, the move is not made and NO is returned. The model is still fine.
    */
    func setPiece(square: ModelSquare) -> Bool {
        let move = ModelMove(setPieceTo: square)
        return makeMoveIfLegal(move)
    }
    

    func dragPiecesFrom(from: ModelSquare, to: ModelSquare, withNumber numberODraggedPieces: Int) -> Bool {
        let modelMove = ModelMove(from: from, to: to, numberOfPieces: numberODraggedPieces)
        return makeMoveIfLegal(modelMove)
    }
    
    
    func makeMoveIfLegal(move: ModelMove) -> Bool {
        if isMoveLegal(move) {
            mixtour.makeMove(&coreBoard, move.coreMove())
            return true
        } else {
            return false
        }
    }
    

    func isMoveLegal(move: ModelMove) -> Bool {
        return mixtour.isMoveLegal(&coreBoard, move.coreMove())
    }

    
    func isSettingPossible() -> Bool {
        return mixtour.isSettingPossible(&coreBoard)
    }
    
    
    func isDraggingPossible() -> Bool {
        return mixtour.isDraggingPossible(&coreBoard)
    }
    
    
    func isSettingOrDraggingPossbile() -> Bool {
        return true
    }
    

    func allLegalMoves() -> [ModelMove] {
        var swiftMoves = [ModelMove]()
        let cMoves = mixtour.arrayOfLegalMoves(&coreBoard)
        for i in 0..<cMoves.n {
            let coreMove = cMoves.a[i]
            swiftMoves.append(ModelMove(coreMove: coreMove))
        }
        mixtour.destroyMoveArray(cMoves)
        return swiftMoves
    }
}
