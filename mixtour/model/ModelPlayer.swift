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
        switch corePlayer.rawValue {
        case MIXCorePlayerWhite.rawValue:
            self = .White
        case MIXCorePlayerBlack.rawValue:
            self = .Black
        default:
            self = .Undefined
        }
    }
    
    func corePlayer() -> MIXCorePlayer {
        switch self {
        case .White:
            return MIXCorePlayerWhite
        case .Black:
            return MIXCorePlayerBlack
        default:
            return MIXCorePlayerUndefined
        }
    }
}
