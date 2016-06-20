//
//  ModelPlayer.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 25/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//


enum ModelPlayer: Int {
    case undefined = -1  // TODO: Maybe use Swift optional and failable initializer instead?
    case white = 0
    case black = 1
    
    init(corePlayer: MIXCorePlayer) {
        switch corePlayer.rawValue {
        case MIXCorePlayerWhite.rawValue:
            self = .white
        case MIXCorePlayerBlack.rawValue:
            self = .black
        default:
            self = .undefined
        }
    }
    
    func corePlayer() -> MIXCorePlayer {
        switch self {
        case .white:
            return MIXCorePlayerWhite
        case .black:
            return MIXCorePlayerBlack
        default:
            return MIXCorePlayerUndefined
        }
    }
}
