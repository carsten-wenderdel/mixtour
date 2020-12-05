//
//  ModelBoardTestExtensions.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 10/05/16.
//  Copyright © 2016 Carsten Wenderdel. All rights reserved.
//

import Core
@testable import mixtour

extension ModelBoard {
    
    func setPiecesDirectlyToSquare(_ square: ModelSquare, _ args: ModelPlayer...) {
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
