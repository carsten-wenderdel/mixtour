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