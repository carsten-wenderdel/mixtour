//
//  ModelBoardTestExtensions.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 10/05/16.
//  Copyright © 2016 Carsten Wenderdel. All rights reserved.
//

@testable import mixtour

extension ModelBoard {
    
    func setPiecesDirectlyToSquare(square: ModelSquare, _ args: ModelPlayer...) {
        var corePlayers: [CVarArgType] = [CVarArgType]()
        for modelPlayer in args {
            corePlayers.append(modelPlayer.rawValue)
        }
        mixtour.setPiecesDirectlyWithList(&coreBoard, square.coreSquare(), Int32(corePlayers.count), getVaList(corePlayers))
    }
    
    func setTurnDirectly(player: ModelPlayer) {
        mixtour.setTurnDirectly(&coreBoard, player.corePlayer())
    }
}