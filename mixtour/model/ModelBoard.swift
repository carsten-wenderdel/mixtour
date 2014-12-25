//
//  ModelBoard.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 24/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation

class ModelBoard: MIXModelBoard {
    
    func winner() -> MIXCorePlayer {
        // TODO: Remove tempVar
        var tempVar = self.coreBoard
        return mixtour.winner(&tempVar)
    }

}