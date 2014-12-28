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
        return ModelPlayer(corePlayer: corePlayer)
    }
    
    
    func playerOnTurn() -> ModelPlayer {
        let corePlayer = mixtour.playerOnTurn(&coreBoard)
        return ModelPlayer(corePlayer: corePlayer)
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
        return ModelPlayer(corePlayer: corePlayer)
    }
    
    
    /**
    If this is a legal move, it returns YES.
    If it's an illegal move, the move is not made and NO is returned. The model is still fine.
    */
    func setPiece(square: ModelSquare) -> Bool {
        let coreSquare = square.coreSquare()
    
        if !mixtour.isSquareEmpty(&coreBoard, coreSquare) {
            return false
        }

        let player = mixtour.playerOnTurn(&coreBoard)
        if mixtour.numberOfPiecesForPlayer(&coreBoard, player) <= 0 {
            return false
        }
        
        // ok, it's a legal move
        mixtour.setPiece(&coreBoard, coreSquare)
        return true
    }
    

    func dragPiecesFrom(from: ModelSquare, to: ModelSquare, withNumber numberODraggedPieces: Int) -> Bool {
        let coreFrom = from.coreSquare()
        let coreTo = to.coreSquare()
        if mixtour.isDragLegal(&coreBoard, coreFrom, coreTo) {
            mixtour.dragPieces(&coreBoard, coreFrom, coreTo, UInt8(numberODraggedPieces))
            return true
        } else {
            return false
        }
    }
    

    func isDragLegalFrom(from: ModelSquare, to: ModelSquare) -> Bool {
        return isDragLegal(&coreBoard, from.coreSquare(), to.coreSquare())
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