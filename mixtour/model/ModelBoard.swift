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
    
    var coreBoard: MIXCoreBoard
    
    init() {
        // put coreBoard on stack:
        coreBoard = mixtour.createNonInitializedCoreBoard()
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
        let coreSquare = square.coreSquare()
        let move = ModelMove(setPieceTo: square)
        
        if !isMoveLegal(move) {
            return false
        } else {
            mixtour.setPiece(&coreBoard, coreSquare)
            return true
        }
    }
    

    func dragPiecesFrom(from: ModelSquare, to: ModelSquare, withNumber numberODraggedPieces: Int) -> Bool {
        let coreFrom = from.coreSquare()
        let coreTo = to.coreSquare()
        let modelMove = ModelMove(from: from, to: to)
        if isMoveLegal(modelMove) {
            mixtour.dragPieces(&coreBoard, coreFrom, coreTo, UInt8(numberODraggedPieces))
            return true
        } else {
            return false
        }
    }
    

    func isMoveLegal(move: ModelMove) -> Bool {
        return mixtour.isMoveLegal(&coreBoard, move.coreMove());
    }

    
    func isSettingPossible() -> Bool {
        let player = mixtour.playerOnTurn(&coreBoard)
        if (mixtour.numberOfPiecesForPlayer(&coreBoard, player) <= 0) {
            return false
        }
        
        for i in 0..<numberOfSquares {
            for j in 0..<numberOfSquares {
                if mixtour.isSquareEmpty(&coreBoard, MIXCoreSquare(column: UInt8(i), line: UInt8(j))) {
                    return true
                }
            }
        }
        
        return false
    }
    
    
    func isDraggingPossible() -> Bool {
        return true
    }
    
    
    func isSettingOrDraggingPossbile() -> Bool {
        return true
    }
}