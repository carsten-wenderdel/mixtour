//
// Created by Carsten Wenderdel on 2015-04-02.
// Copyright (c) 2015 Carsten Wenderdel. All rights reserved.
//

import Foundation
import Core

public enum Move {
    case set(to: Square)
    case drag(from: Square, to: Square, numberOfPieces: Int)

    func coreMove() -> MIXCoreMove {
        switch self {
        case .set(let to):
            return Core.MIXCoreMoveMakeSet(to.coreSquare())
        case .drag(let from, let to, let numberOfPieces):
            return Core.MIXCoreMoveMakeDrag(from.coreSquare(), to.coreSquare(), UInt8(numberOfPieces))
        }
    }
}

// Second initializer in an extension to keep the default initializer.
// See "Initializer Delegation for Value Types" in "The Swift Programming Language"
extension Move {
    init(_ coreMove: MIXCoreMove) {
        if Core.isMoveDrag(coreMove) {
            self = .drag(from: Square(coreMove.from), to: Square(coreMove.to), numberOfPieces: Int(coreMove.numberOfPieces))
        } else {
            self = .set(to: Square(coreMove.to))
        }
    }
}


extension Move: Equatable {}

public func ==(lhs: Move, rhs: Move) -> Bool {
    return MIXCoreMoveEqualToMove(lhs.coreMove(), rhs.coreMove())
}
