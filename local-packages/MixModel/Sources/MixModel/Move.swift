//
// Created by Carsten Wenderdel on 2015-04-02.
// Copyright (c) 2015 Carsten Wenderdel. All rights reserved.
//

import Foundation
import Core

let kMoveSetIndicator = 6

public struct Move {
    public let from, to: Square
    public let numberOfPieces: Int

    public init(from: Square, to: Square, numberOfPieces: Int) {
        self.from = from
        self.to = to
        self.numberOfPieces = numberOfPieces
    }

    func coreMove() -> MIXCoreMove {
        return MIXCoreMove(from: from.coreSquare(), to: to.coreSquare(), numberOfPieces: UInt8(numberOfPieces))
    }
    
    public func isMoveDrag() -> Bool {
        return from.column != kMoveSetIndicator;
    }
}

// Second initializer in an extension to keep the default initializer.
// See "Initializer Delegation for Value Types" in "The Swift Programming Language"
extension Move {

    public init(setPieceTo: Square) {
        from = Square(column:kMoveSetIndicator, line:0) // 0 is not important, just any number is fine
        to = setPieceTo
        numberOfPieces = 0
    }

    init(coreMove: MIXCoreMove) {
        from = Square(coreSquare: coreMove.from)
        to = Square(coreSquare: coreMove.to)
        numberOfPieces = Int(coreMove.numberOfPieces)
    }
}


extension Move: Equatable {}

public func ==(lhs: Move, rhs: Move) -> Bool {
    return MIXCoreMoveEqualToMove(lhs.coreMove(), rhs.coreMove())
}
