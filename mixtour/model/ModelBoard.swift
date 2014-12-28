//
//  ModelBoard.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 24/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation


let numberOfSquares = 5


class ModelBoard: MIXModelBoard {
    
    func winner() -> ModelPlayer {
        // TODO: Remove tempVar
        var tempVar = self.coreBoard
        let corePlayer = mixtour.winner(&tempVar)
        return ModelPlayer(corePlayer: corePlayer)
    }
    
    
    func numberOfPiecesForPlayer(player: ModelPlayer) -> Int {
        // TODO: Remove tempBoard
        var tempBoard = self.coreBoard
        return Int(mixtour.numberOfPiecesForPlayer(&tempBoard, player.corePlayer()))
    }
    
    
    func isSquareEmpty(square: ModelSquare) -> Bool {
        // TODO: Remove tempBoard
        var tempBoard = self.coreBoard
        return mixtour.isSquareEmpty(&tempBoard, square.coreSquare())
    }
    
    
    func heightOfSquare(square: ModelSquare) -> Int {
        // TODO: Remove tempBoard
        var tempBoard = self.coreBoard
        return Int(mixtour.heightOfSquare(&tempBoard, square.coreSquare()))
    }
    
    
    func colorOfSquare(square: ModelSquare, atPosition position: Int) -> ModelPlayer{
        // TODO: Remove tempBoard
        var tempBoard = self.coreBoard
        let corePlayer = colorOfSquareAtPosition(&tempBoard, square.coreSquare(), UInt8(position))
        return ModelPlayer(corePlayer: corePlayer)
    }
    
    
    /**
    If this is a legal move, it returns YES.
    If it's an illegal move, the move is not made and NO is returned. The model is still fine.
    */
    func setPiece(square: ModelSquare) -> Bool {
        // TODO: Remove tempBoard
        var tempBoard = self.coreBoard
        let coreSquare = square.coreSquare()
    
        if !mixtour.isSquareEmpty(&tempBoard, coreSquare) {
            return false
        }

        let player = mixtour.playerOnTurn(&tempBoard)
        if mixtour.numberOfPiecesForPlayer(&tempBoard, player) <= 0 {
            return false
        }
        
        // ok, it's a legal move
        mixtour.setPiece(&tempBoard, coreSquare)
        self.coreBoard = tempBoard
        return true
    }
    

    func dragPiecesFrom(from: ModelSquare, to: ModelSquare, withNumber numberODraggedPieces: Int) -> Bool {
        // TODO: Remove tempBoard
        var tempBoard = self.coreBoard
        let coreFrom = from.coreSquare()
        let coreTo = to.coreSquare()
        if mixtour.isDragLegal(&tempBoard, coreFrom, coreTo) {
            mixtour.dragPieces(&tempBoard, coreFrom, coreTo, UInt8(numberODraggedPieces))
            self.coreBoard = tempBoard
            return true
        } else {
            return false
        }
    }
    

    func isDragLegalFrom(from: ModelSquare, to: ModelSquare) -> Bool {
        // TODO: Remove tempBoard
        var tempBoard = self.coreBoard
        return isDragLegal(&tempBoard, from.coreSquare(), to.coreSquare())
    }

    
    func isSettingPossible() -> Bool {
        // TODO: Remove tempBoard
        var tempBoard = self.coreBoard
        let player = mixtour.playerOnTurn(&tempBoard)
        if (mixtour.numberOfPiecesForPlayer(&tempBoard, player) <= 0) {
            return false
        }
        
        for i in 0..<numberOfSquares {
            for j in 0..<numberOfSquares {
                if mixtour.isSquareEmpty(&tempBoard, MIXCoreSquare(column: UInt8(i), line: UInt8(j))) {
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