//
//  ModelBoard.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 24/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation

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

}