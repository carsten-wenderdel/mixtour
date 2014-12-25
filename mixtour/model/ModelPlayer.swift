//
//  ModelPlayer.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 25/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//


enum ModelPlayer: Int {
    case Undefined = -1  // TODO: Maybe use Swift optional and failable initializer instead?
    case White = 0
    case Black = 1
    
    init(corePlayer: MIXCorePlayer) {
        switch corePlayer.value {
        case MIXCorePlayerWhite.value:
            self = .White
        case MIXCorePlayerBlack.value:
            self = .Black
        default:
            self = .Undefined
        }
    }
}
